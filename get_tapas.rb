require 'mechanize'

def say(msg)
  puts "=> #{msg}"
end

def exit_with(msg)
  say msg
  say "...exiting..."
  exit
end

a = Mechanize.new

puts "Logging in..."

a.get('https://rubytapas.dpdcart.com/subscriber/content') do |page|
  content_page = page.form_with(id: 'login-form') do |f|
    f.username = 'user@example.com'
    f.password = 'password'
  end.click_button

  # show the title of the page
  say "Got page: " + content_page.title

  # exit if login attempt fails
  exit_with("Couldn't log in") if content_page.title =~ /Login/

  a.page.parser.css('div.blog-entry').each do |entry|
    entry_title = entry.css('h3').first.content rescue nil

    # if there's no entry title, skip to the next blog_entry
    entry_title ? say("Found entry: " + entry_title) : next

    # create a directory name using the entry_title
    dir_name = entry_title.gsub(/\W/, '_')

    if Dir.exists?(dir_name)
      say "#{dir_name} already exists, skipping..."
      next
    else
      say "Creating directory: " + dir_name
      Dir.mkdir(dir_name)
    end

    Dir.chdir(dir_name)
    say "in directory: " + `pwd`

    # click attachments link
    url = entry.css('div.content-post-meta a').first['href'] rescue nil

    if url
      download_page = a.get(url)
      say "Downloading files at: " + download_page.title

      # get array of links with matching regex
      download_page.links_with(:href => /subscriber\/download/).each do |link|
        say "Downlading..." + link.inspect
        # simulate click on link to download
        file = a.click(link)
        # save stream to a file
        File.open(file.filename, 'w+b') do |f|
          f << file.body.strip
        end
      end
    else
      say "Couldn't find url #{url}. Skipping..."
    end

    Dir.chdir('..')
    say "back out: " + `pwd`
  end
end