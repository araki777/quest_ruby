require 'singleton'

module BorrowStatus
  AVAILABLE = :available
  BORROWED = :borrowed

  STATUS_LABLES = {
    AVAILABLE => "利用可能",
    BORROWED => "貸出中"
  }
end

class BorrowState
  def borrow(book)
    raise NotImplementedError
  end

  def status
    raise NotImplementedError
  end
end

class AvailableState < BorrowState
  include Singleton

  def borrow(book)
    book.state = BorrowedState.instance
    puts "『#{book.title}』を貸し出しました。"
  end

  def status
    BorrowStatus::AVAILABLE
  end
end

class BorrowedState < BorrowState
  include Singleton

  def borrow(book)
    puts "『#{book.title}』はすでに貸し出されています。"
    false
  end

  def status
    BorrowStatus::BORROWED
  end
end

class Book
  attr_reader :title, :author
  attr_accessor :state

  def initialize(title, author)
    @title = title
    @author = author
    @state = AvailableState.instance
  end

  def borrow
    @state.borrow(self)
  end

  def status
    @state.status
  end

  def info
    "『#{@title}』 by #{@author} [#{BorrowStatus::STATUS_LABLES[status]}]"
  end
end

class Library
  def initialize
    @books = []
  end

  def add_book(book)
    @books << book
  end

  def list_books
    @books.each do |book|
      puts book.info
    end
  end

  def borrow_book(title)
    book = @books.find { |b| b.title == title }
    if book
      book.borrow
    else
      puts "『#{title}』は図書館にありません。"
      false
    end
  end
end

library = Library.new
library.add_book(Book.new("ハリーポッター", "J.K.ローリング"))
library.add_book(Book.new("1984", "ジョージ・オーウェル"))

library.list_books
library.borrow_book("ハリーポッター")
library.borrow_book("ハリーポッター")
library.list_books