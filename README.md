## Welcome to Scrooge

This is a simple invoice and tracking application suited for small companies.

What can you do with scrooge?

- Tracking your daily job activities
- Managing the job orders and checking their status
- Creating an invoice 
- Generate a pdf-invoice
- Tacking expenses
- Tracking invoice payment status
- View the current status (economics, in/out)
- Managing users
- Managing customers
- **NEW Real-time activity tracker**

It's built on **Rails 4.0**.

You can find a live demo: [http://plasticscrooge-demo.herokuapp.com/](http://plasticscrooge-demo.herokuapp.com/)
Use this credentials:

user: demo@codiceplastico.com

pwd: demopwd

### Installation
1. Clone the repository
2. Install the gems with `bundle install`
3. Setup the database `rake db:migrate` and `rake db:seed`
4. Start the server `rails s`

### Configuration
There are some settings that you have to set in the setting page.
These are:

- IBAN the bank account number
- DROPBOX_ENABLED (true or false) enable and disable dropbox service
- DROPBOX_APP_KEY
- DROPBOX_APP_SECRET
- DROPBOX_TOKEN
- DROPBOX_SECRET
- DROPBOX_FOLDER
- DROPBOX_APP_MODE
- FISCAL_YEAR the default year used to create the invoices

To obtain the keys for DROPBOX you can read this http://ema.codiceplastico.com/blog/2013/03/22/usare-dropbox-da-unapplicazione-rails/


### Version history 
- 11-04-2013 Drop 1 (first release with basic functionalities)
- 10-09-2013 Drop 2 (migrated to Rails 4.0 and Ruby 2.0)
- 02-10-2013 Drop 3 (Activity tracker and bug fixes)
- 11-10-2013 Drop 4 (new design based on Boostrap 3.0)
- 15-11-2013 Drop 5 (added settings and year-month filter in invoice view)


### Screenshots
![img](doc/images/img1.png)
***
![img](doc/images/img2.png)
***
![img](doc/images/img3.png)
***
![img](doc/images/img4.png)
***
![img](doc/images/img5.png)
***
![img](doc/images/img6.png)
***
![img](doc/images/img7.png)
***
![img](doc/images/img8.png)
***
![img](doc/images/img9.png)
***
![img](doc/images/img10.png)
***
![img](doc/images/img11.png)
***


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/emadb/scrooge/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

