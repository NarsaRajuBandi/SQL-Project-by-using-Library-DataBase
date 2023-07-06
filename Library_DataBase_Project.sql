create database library;
use library;

create table tbl_publisher(
publisher_PublisherName VARCHAR(255) primary key,
publisher_PublisherAddress VARCHAR(255),
publisher_PublisherPhone VARCHAR(100));

create table tbl_borrower(
borrower_CardNo INT primary key,
borrower_BorrowerName VARCHAR(255),
borrower_BorrowerAddress VARCHAR(255),
borrower_BorrowerPhone VARCHAR(100));

create table tbl_book(
book_BookID INT primary key,
book_Title VARCHAR(255),
book_PublisherName VARCHAR(255),
foreign key (book_PublisherName)
references tbl_publisher(publisher_PublisherName)
on delete cascade);

create table tbl_book_authors(
book_authors_AuthorID INT primary key auto_increment,
book_authors_BookID INT,
book_authors_AuthorName VARCHAR(255),
foreign key(book_authors_BookID)
references tbl_book(book_BookID)
on delete cascade);

create table tbl_library_branch(
library_branch_BranchID INT primary key auto_increment,
library_branch_BranchName VARCHAR(255),
library_branch_BranchAddress VARCHAR(255));

create table tbl_book_copies(
book_copies_CopiesID INT primary key auto_increment,
book_copies_BookID INT,
book_copies_BranchID INT,
book_copies_No_Of_Copies INT,
foreign key(book_copies_BookID)
references tbl_book(book_BookID)
on delete cascade,
foreign key(book_copies_BranchID)
references tbl_library_branch(library_branch_BranchID)
on delete cascade);

create table tbl_book_loans(
book_loans_LoansID INT primary key auto_increment,
book_loans_BookID INT,
book_loans_BranchID INT,
book_loans_CardNo INT,
book_loans_DateOut VARCHAR(100),
book_loans_DueDate VARCHAR(100),
foreign key(book_loans_BookID)
references tbl_book(book_BookID)
on delete cascade,
foreign key(book_loans_BranchID)
references tbl_library_branch(library_branch_BranchID)
on delete cascade,
foreign key(book_loans_CardNo)
references tbl_borrower(borrower_CardNo)
on delete cascade);

select * from tbl_publisher;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_borrower;
select * from tbl_book_copies;
select * from tbl_book_loans;
select * from tbl_library_branch;

-- Task Questions
-- 1>How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select * from tbl_book;
select * from tbl_library_branch;
select * from tbl_book_copies;

select b.book_Title,lb.library_branch_BranchName,bc.book_Copies_No_Of_Copies as count_of_copies
from tbl_book as b
join tbl_book_copies as bc
on b.book_BookID=bc.book_copies_BookID 
join tbl_library_branch as lb
on lb.library_branch_BranchID=bc.book_copies_BranchID where b.book_Title="The Lost Tribe" and lb.library_branch_BranchName="Sharpstown";

-- 2>How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select * from tbl_book;
select * from tbl_library_branch;
select * from tbl_book_copies;

select b.book_Title,lb.library_branch_BranchName,bc.book_copies_No_Of_Copies as count_of_copies
from tbl_book as b
join tbl_book_copies as bc
on b.book_BookID=bc.book_copies_BookID
join tbl_library_branch as lb
on lb.library_branch_BranchID=bc.book_copies_BranchID where book_Title="The Lost Tribe";

-- Other Way:
select  tlb.library_branch_BranchName, tb.book_Title, tbc.book_copies_No_Of_Copies as count_of_copies
from tbl_library_branch tlb 
join tbl_book_copies tbc on tlb.library_branch_BranchID = tbc.book_copies_BranchID
join tbl_book tb on tb.book_BookID=tbc.book_copies_BookID
where tb.book_Title="The Lost Tribe";

-- 3>Retrieve the names of all borrowers who do not have any books checked out.
select * from tbl_borrower;
select * from tbl_book_loans;

select tb.borrower_BorrowerName 
from tbl_borrower as tb 
left join tbl_book_loans as tbl 
on tb.borrower_CardNo=tbl.book_loans_CardNo
where tbl.book_loans_CardNo is Null;

-- 4>For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.

select b.book_Title, tb.borrower_BorrowerName, tb.borrower_BorrowerAddress 
from tbl_library_branch as lb 
join tbl_book_loans as bl 
on lb.library_branch_BranchID=bl.book_loans_BranchID
join tbl_book as b 
on bl.book_loans_BookID = b.book_BookID
join tbl_borrower as tb 
on bl.book_loans_CardNo=tb.borrower_CardNo
where lb.library_branch_BranchName = "Sharpstown" and bl.book_loans_DueDate="2/3/18";

-- 5>For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select* from tbl_library_branch;
select * from tbl_book_loans;

select lb.library_branch_BranchName as Branch_Name, count(book_loans_BranchID) as count_of_books
from tbl_library_branch lb 
join tbl_book_loans bl 
on lb.library_branch_BranchID=bl.book_loans_BranchID
group by Branch_Name;

-- Another Way
select library_branch_BranchName,
(select count(book_loans_BranchID) from tbl_book_loans where book_loans_BranchID = bl.library_branch_BranchID) as count_of_books
from tbl_library_branch as bl;

-- 6>Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select borrower_BorrowerName, borrower_BorrowerAddress,
(select count(book_loans_CardNo) from tbl_book_loans where book_loans_CardNo = tb.borrower_CardNo) as No_of_books_checked_out
from tbl_borrower tb
having  No_of_books_checked_out > 5;

-- 7>For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select * from tbl_book_authors;
select * from tbl_library_branch;
select * from tbl_book_copies;
select * from tbl_book;

select b.book_Title,bc.book_copies_No_Of_Copies,lb.library_branch_BranchName,ba.book_authors_AuthorName
from tbl_book as b
join tbl_book_copies as bc
on b.book_BookID=bc.book_copies_BookID 
join tbl_book_authors as ba
on b.book_BookID=ba.book_authors_AuthorID
join tbl_library_branch as lb
on lb.library_branch_BranchID=bc.book_copies_BranchID where ba.book_authors_AuthorName="stephen king" and lb.library_branch_BranchName="Central";

-- Other Way:
select tb.book_Title, tlb.library_branch_BranchName, tbc.book_copies_No_Of_Copies   
from tbl_book tb 
join tbl_book_authors tba 
on tba.book_authors_BookID=tb.book_BookID
join tbl_book_copies tbc 
on tbc.book_copies_BookID=tb.book_BookID
join tbl_library_branch tlb 
on tlb.library_branch_BranchID=tbc.book_copies_BranchID
where book_authors_AuthorName = "Stephen King" and tlb.library_branch_BranchName = "Central";
