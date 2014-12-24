##tech-support
========

###Setup environment

install rvm
```sh
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
$ curl -sSL https://get.rvm.io | bash
$ rvm install 2.0.0 #in new terminal
```
create gemset
```sh
$ rvm use 2.1.5@tech-support --create --default
```

###Install Mysql database
```sh
$ sudo apt-get install libmysql-ruby libmysql-ruby1.8 libmysqlclient-dev mysql-client mysql-server
```

###NodeJs
```sh
$ curl https://raw.githubusercontent.com/creationix/nvm/v0.11.1/install.sh | bash
$ source ~/.profile
$ nvm install 0.10.33 #in new terminal
```

###Rails
```sh
$ gem install rails
```

###Clone project

```sh
$ git clone git@github.com:dmytrokomisaryk/TechSupport.git
$ cd TechSupport
```

###Install gems

```sh
$ bundle install
```

###Run app

```sh
$ rails s
```

###Create staff

Visit `http://localhost:3000/admin` and log in using:

```ruby
User: admin@tech-support.com
Password: password
```

Click `Staff` tab then click `New Staff` button.