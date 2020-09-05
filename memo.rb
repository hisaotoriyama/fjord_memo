# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'json'
require 'pg'

get '/' do
  @contents = read_all
  erb :top
end

get '/new' do
  erb :new
end

post '/create' do
  add_new
  redirect '/'
end

get '/show/:id' do
  @content = read_selected
  erb :show
end

get '/edit/:id' do
  @id = params['id']
  @todo = params['todo']
  @detail = params['detail']
  erb :edit
end

patch '/' do
  update_selected
  redirect '/'
end

delete '/delete/:id' do
  delete_selected
  redirect '/'
end

get '/layout' do
  erb :layout
end

def read_all
  connection = PG.connect(dbname: 'memodb', port: '5432')
  results = connection.exec('SELECT * FROM memo_table;')
  convert_memodata(results)
end

def read_selected
  id_num = params['id'].to_i
  connection = PG.connect(dbname: 'memodb', port: '5432')
  results = connection.exec("SELECT * FROM memo_table WHERE id ='#{id_num}';")
  convert_memodata(results).first
end

def convert_memodata(results)
  all_data = []
  results.each do |result|
    # #idがなぜかntegerからstringsになっていたので修正
    result['id'] = result['id'].to_i
    all_data << result
  end
  all_data
end

def delete_selected
  id_num = params['id'].to_i
  connection = PG.connect(dbname: 'memodb', port: '5432')
  connection.exec("DELETE FROM memo_table WHERE id ='#{id_num}';")
end

def update_selected
  id_num = params['id'].to_i
  todo = params['todo']
  detail = params['detail']
  connection = PG.connect(dbname: 'memodb', port: '5432')
  connection.exec("UPDATE memo_table SET todo = '#{todo}', detail='#{detail}' WHERE id ='#{id_num}';")
end

def add_new
  todo = params['todo']
  detail = params['detail']
  connection = PG.connect(dbname: 'memodb', port: '5432')
  connection.exec("INSERT INTO memo_table (todo, detail) VALUES ('#{todo}', '#{detail}');")
end
