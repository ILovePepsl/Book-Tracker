require 'nokogiri'
require 'open-uri'
require 'csv'

MAX_RETRIES = 5

namespace :books do
  desc "Import books from Goodreads"
  task import: :environment do

    def fetch_page(url, retries = 0)
      begin
        Nokogiri::HTML(URI.open(url))
      rescue StandardError => e
        if retries < MAX_RETRIES
          retries += 1
          puts "Error fetching #{url}: #{e.message}. Retrying (#{retries}/#{MAX_RETRIES})..."
          sleep(2 ** retries)
          retry
        else
          puts "Failed to fetch #{url} after #{MAX_RETRIES} attempts."
          nil
        end
      end
    end

    def parse_book_page(book_url)
      page = fetch_page("https://www.goodreads.com#{book_url}")
      return nil unless page

      title = page.css('h1[data-testid="bookTitle"]').text.strip rescue nil
      author = page.css('span.ContributorLink__name[data-testid="name"]').first&.text&.strip || "Unknown Author"
      description = page.css('div[data-testid="description"] div.TruncatedContent__text span.Formatted').text.strip rescue "No description available."
      image_url = page.css('div.BookCard__cover img.ResponsiveImage').attr('src').value.strip rescue nil
      genres = page.css('div[data-testid="genresList"] a.Button--tag-inline span.Button__labelItem').map(&:text).join(", ").strip rescue "No genres available."

      { title: title, author: author, description: description, image_url: image_url, genres: genres }
    end

    def parse_list_page(url)
      page = fetch_page(url)
      return unless page

      book_rows = page.css('tr[itemtype="http://schema.org/Book"]')
      total_books = book_rows.length
      puts "Found #{total_books} books to parse on page #{url.split('=').last}."

      book_rows.each_with_index do |book_row, index|
        book_link = book_row.css('a.bookTitle').attr('href').value
        puts "Parsing book #{index + 1} on page #{url.split('=').last}: #{book_link}"
        book_details = parse_book_page(book_link)
        if book_details
          author = Author.find_or_create_by(name: book_details[:author]) do |a|
            a.bio = "Biography of #{book_details[:author]}"
          end

          book = Book.new(
            title: book_details[:title],
            description: book_details[:description],
            author: author,
            general_library: true
          )

          if book_details[:image_url].present?
            image = URI.open(book_details[:image_url])
            book.cover_image.attach(io: image, filename: File.basename(book_details[:image_url]))
          end

          book.save!

          genres = book_details[:genres].split(", ").map do |genre|
            Category.find_or_create_by(name: genre)
          end

          book.categories << genres

          puts "Successfully parsed and saved book #{index + 1}: #{book_details[:title]}"
        else
          puts "Failed to parse book #{index + 1}: #{book_link}"
        end

        if (index + 1) % 20 == 0
          puts "Parsed #{index + 1} out of #{total_books} books on page #{url.split('=').last}"
        end
      end
    end

    def get_total_pages(url)
      page = fetch_page(url)
      return 1 unless page

      pagination_links = page.css('div.pagination a[href*="page="]').map { |link| link.text.to_i }
      pagination_links.max
    end

    base_url = 'https://www.goodreads.com/list/show/1.Best_Books_Ever'
    total_pages = get_total_pages(base_url)

    puts "Starting to parse list pages. Total pages: #{total_pages}"

    (1..total_pages).each do |page_number|
      list_url = "#{base_url}?page=#{page_number}"
      puts "Parsing page #{page_number} of #{total_pages}: #{list_url}"
      parse_list_page(list_url)
    end

    puts "Finished parsing and saving books."
  end
end
