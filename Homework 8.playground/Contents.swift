import Foundation


//1.შევქმნათ Class Book.
//Properties: bookID(უნიკალური იდენტიფიკატორი Int), String title, String author, Bool isBorrowed.
//Designated Init.
//Method რომელიც ნიშნავს წიგნს როგორც borrowed-ს.
//Method რომელიც ნიშნავს წიგნს როგორც დაბრუნებულს.

class Book {
    let bookID: Int
    var title: String
    var author: String
    var isBorrowed: Bool
    
    init(bookID: Int, title: String, author: String, isBorrowed: Bool) {
        self.bookID = bookID
        self.title = title
        self.author = author
        self.isBorrowed = isBorrowed
    }
    
    func markAsBorrowed() -> Bool {
        if isBorrowed {
            print("This book is already borrowed.")
            return false
        }
        isBorrowed = true
        print("The book '\(title)' has been marked as borrowed.")
        return true
    }
    
    func markAsReturned() -> Bool {
        if isBorrowed {
            isBorrowed = false
            print("The book '\(title)' has been marked as returned.")
            return true
        }
        print("This book is not currently borrowed.")
        return false
    }
}

let book = Book(bookID: 1, title: "Secrets of the Realm", author: "Bev Stout", isBorrowed: false)
book.markAsBorrowed()


//2.შევქმნათ Class Owner
//
//Properties: ownerId(უნიკალური იდენტიფიკატორი Int), String name, Books Array სახელით borrowedBooks.
//Designated Init.
//Method რომელიც აძლევს უფლებას რომ აიღოს წიგნი ბიბლიოთეკიდან.
//Method რომელიც აძლევს უფლებას რომ დააბრუნოს წაღებული წიგნი.

class Owner {
    let ownerId: Int
    var name: String
    var borrowedBooks: [Book]
    
    init(ownerId: Int, name: String, borrowedBooks: [Book] = []) {
        self.ownerId = ownerId
        self.name = name
        self.borrowedBooks = borrowedBooks
    }
    
    func borrowBook(_ book: Book) {
        if !book.isBorrowed {
            borrowedBooks.append(book)
            book.markAsBorrowed()
            print("\(name), you have permission to take the book '\(book.title)' from the library.")
        } else {
            print("\(name), you do not have permission to take the book '\(book.title)' from the library.")
        }
    }
    
    func returnBook(_ book: Book) {
        if let index = borrowedBooks.firstIndex(where: { $0.bookID == book.bookID }) {
            borrowedBooks.remove(at: index)
            book.markAsReturned()
        }
    }
}

let owner = Owner(ownerId: 1, name: "Dua Lipa", borrowedBooks: [book])
owner.borrowBook(book)

//3. შევქმნათ Class Library
//
//Properties: Books Array, Owners Array.
//Designated Init.
//Method წიგნის დამატება, რათა ჩვენი ბიბლიოთეკა შევავსოთ წიგნებით.
//Method რომელიც ბიბლიოთეკაში ამატებს Owner-ს.
//Method რომელიც პოულობს და აბრუნებს ყველა ხელმისაწვდომ წიგნს.
//Method რომელიც პოულობს და აბრუნებს ყველა წაღებულ წიგნს.
//Method რომელიც ეძებს Owner-ს თავისი აიდით თუ ეგეთი არსებობს.
//Method რომელიც ეძებს წაღებულ წიგნებს კონკრეტული Owner-ის მიერ.
//Method რომელიც აძლევს უფლებას Owner-ს წააღებინოს წიგნი თუ ის თავისუფალია.

class Library {
    var books: [Book]
    var owners: [Owner]
    
    init(books: [Book] = [], owners: [Owner] = []) {
        self.books = books
        self.owners = owners
    }
    
    func addBook(_ book: Book) {
        books.append(book)
    }
    
    func addOwner(_ owner: Owner) {
        owners.append(owner)
    }
    
    func availableBooks() -> [Book] {
        let available = books.filter { !$0.isBorrowed }
        return available
    }
    
    func borrowedBooks() -> [Book] {
        let borrowed = books.filter { $0.isBorrowed }
        return borrowed
    }
    
    func findOwnerByID(_ ownerId: Int) -> Owner? {
        return owners.first { $0.ownerId == ownerId }
    }
    
    func booksBorrowedByOwner(_ owner: Owner) -> [Book] {
        return owner.borrowedBooks
    }
    
    func borrowBook(_ book: Book, by owner: Owner) {
        if !book.isBorrowed {
            owner.borrowBook(book)
        } else {
            print("Sorry, '\(book.title)' is already borrowed.")
        }
    }
    func returnBook(ownerId: Int, bookID: Int) {
        guard let ownerIndex = owners.firstIndex(where: { $0.ownerId == ownerId }) else {
            print("Owner not found.")
            return
        }
        
        guard let bookIndex = owners[ownerIndex].borrowedBooks.firstIndex(where: { $0.bookID == bookID }) else {
            print("Book not found.")
            return
        }
        
        books.first(where: { $0.bookID == bookID })?.isBorrowed = false
        owners[ownerIndex].borrowedBooks.remove(at: bookIndex)
        print("Book has been returned by \(owners[ownerIndex].name).")
    }
    
    
    func printCheckedOutBooks() {
        let checkedOut = borrowedBooks()
        if checkedOut.isEmpty {
            print("No books are currently checked out from the library.")
        } else {
            print("Checked out books:")
            for book in checkedOut {
                print("\(book.title) by \(book.author)")
            }
        }
    }
    
    func printAvailableBooks() {
        let available = availableBooks()
        if available.isEmpty {
            print("There are no available books in the library.")
        } else {
            print("Available books:")
            for book in available {
                print("\(book.title) by \(book.author)")
            }
        }
    }
    
    func printCheckedOutBooks(for owner: Owner) {
        if let foundOwner = findOwnerByID(owner.ownerId) {
            let borrowedBooks = booksBorrowedByOwner(foundOwner)
            if borrowedBooks.isEmpty {
                print("\(owner.name) has not borrowed any books.")
            } else {
                print("\(owner.name)'s checked out books:")
                for book in borrowedBooks {
                    print("\(book.title) by \(book.author)")
                }
            }
        } else {
            print("Owner not found.")
        }
    }
}


let library = Library()

library.addOwner(owner)
library.borrowBook(book, by: owner)
library.borrowBook(book, by: owner)


if let foundOwner = library.findOwnerByID(1) {
    let booksBorrowed = library.booksBorrowedByOwner(foundOwner)
    print("\(foundOwner.name) has borrowed \(booksBorrowed.map { $0.title })")
} else {
    print("Owner not found.")
}


//4.გავაკეთოთ ბიბლიოთეკის სიმულაცია.
//
//შევქმნათ რამოდენიმე წიგნი და რამოდენიმე Owner-ი, შევქმნათ ბიბლიოთეკა.
//დავამატოთ წიგნები და Owner-ები ბიბლიოთეკაში
//წავაღებინოთ Owner-ებს წიგნები და დავაბრუნებინოთ რაღაც ნაწილი.
//დავბეჭდოთ ინფორმაცია ბიბლიოთეკიდან წაღებულ წიგნებზე, ხელმისაწვდომ წიგნებზე და გამოვიტანოთ წაღებული წიგნები კონკრეტულად ერთი Owner-ის მიერ.

let book1 = Book(bookID: 1, title: "To Kill a Mockingbird", author: "Harper Lee", isBorrowed: false)
let book2 = Book(bookID: 2, title: "Avalon High", author: "Meg Cabot", isBorrowed: true)
let book3 = Book(bookID: 3, title: "The Catcher in the Rye", author: "J.D. Salinger", isBorrowed: false)
let book4 = Book(bookID: 4, title: "Fear of Flying", author: "Erica Jong", isBorrowed: false)

let owner1 = Owner(ownerId: 2, name: "Sam Smith")
let owner2 = Owner(ownerId: 3, name: "Taylor Swift")
let owner3 = Owner(ownerId: 4, name: "Celine Dion")

library.addBook(book1)
library.addBook(book2)
library.addBook(book3)
library.addBook(book4)

library.addOwner(owner1)
library.addOwner(owner2)
library.addOwner(owner3)

library.borrowBook(book1, by: owner1)
library.borrowBook(book2, by: owner2)
library.borrowBook(book3, by: owner2)
library.returnBook(ownerId: 4, bookID: 3)
library.returnBook(ownerId: 1, bookID: 1)

owner1.returnBook(book1)
owner2.returnBook(book2)

print("Books checked out from the library:")
for owner in library.owners {
    let borrowedBooks = library.booksBorrowedByOwner(owner)
    print("\(owner.name) has borrowed: \(borrowedBooks.map { $0.title })")
}

print("Available Books in the library:")
let availableBooks = library.availableBooks()
for book in availableBooks {
    print("\(book.title) by \(book.author)")
}

print("Borrowed Books in the library:")
let borrowedBooks = library.borrowedBooks()
for book in borrowedBooks {
    print("\(book.title) by \(book.author)")
}

library.printCheckedOutBooks()
library.printAvailableBooks()

if let owner = library.findOwnerByID(3) {
    library.printCheckedOutBooks(for: owner)
} else {
    print("Owner not found.")
}

