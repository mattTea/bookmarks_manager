require 'pg'

class Bookmark
  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id = id
    @title = title
    @url = url
  end
  
  def self.create(url:, title:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect( dbname: 'bookmark_manager_test' )
    else
      connection = PG.connect( dbname: 'bookmark_manager' )
    end

    result = connection.exec("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
    # to return newly created Bookmark, wrapped in a bookmark object...
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.all
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect( dbname: 'bookmark_manager_test' )
    else
      connection = PG.connect( dbname: 'bookmark_manager' )
    end
    
    result = connection.exec( "SELECT * FROM bookmarks;" )
    list = result.map do |bookmark|
      Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
    end
  end

  def self.delete(id:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect( dbname: 'bookmark_manager_test' )
    else
      connection = PG.connect( dbname: 'bookmark_manager' )
    end
    connection.exec("DELETE FROM bookmarks WHERE id = '#{id}';")
  end

  def self.find_by_id(id:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect( dbname: 'bookmark_manager_test' )
    else
      connection = PG.connect( dbname: 'bookmark_manager' )
    end
    result = connection.exec("SELECT * FROM bookmarks WHERE id = '#{id}';")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.update(id:, url:, title:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect( dbname: 'bookmark_manager_test' )
    else
      connection = PG.connect( dbname: 'bookmark_manager' )
    end

    result = connection.exec("UPDATE bookmarks SET url = '#{url}', title = '#{title}' WHERE id = '#{id}'")
    Bookmark.find_by_id(id: id)
  end
end