# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
匿名でTwitterに投稿できるフォームです。
悪質な投稿を防ぐため相互チェック制を取っています。他の利用者から３回承認された内容のみ投稿されます。他の利用者から３回却下された内容は投稿されません。
一度投稿するために３回の投稿チェックを行っていただきます。
行った投稿が多数却下されている場合は、サービスの利用を停止します。
承認／却下の判断が不適切（他の利用者と多数食い違っている）場合、サービスの利用を停止します。


* Deployment instructions

* ...
