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
  todo = params['todo']
  detail = params['detail']
  add_new(todo, detail)
  redirect '/'
end

get '/show/:id' do
  id_num = params['id'].to_i
  @content = read_selected(id_num)
  erb :show
end

get '/edit/:id' do
  @id = params['id']
  @todo = params['todo']
  @detail = params['detail']
  erb :edit
end

patch '/' do
  id_num = params['id'].to_i
  todo = params['todo']
  detail = params['detail']
  update_selected(id_num, todo, detail)
  redirect '/'
end

delete '/delete/:id' do
  id_num = params['id'].to_i
  delete_selected(id_num)
  redirect '/'
end

get '/layout' do
  erb :layout
end

def read_all
  results = db_connect.exec('SELECT * FROM memo_table;')
  convert_memodata(results)
end

def read_selected(id_num)
  results = db_connect.exec("SELECT * FROM memo_table WHERE id ='#{id_num}';")
  convert_memodata(results).first
end

def convert_memodata(results)
  all_data = []
  results.each do |result|
    result['id'] = result['id'].to_i
    all_data << result
  end
  all_data
end

def delete_selected(id_num)
  db_connect.exec("DELETE FROM memo_table WHERE id ='#{id_num}';")
end

def update_selected(id_num, todo, detail)
  db_connect.exec("UPDATE memo_table SET todo = '#{todo}', detail='#{detail}' WHERE id ='#{id_num}';")
end

def add_new(todo, detail)
  db_connect.exec("INSERT INTO memo_table (todo, detail) VALUES ('#{todo}', '#{detail}');")
end

DB = 'memodb'
PORT = '5432'
def db_connect
  PG.connect(dbname: DB, port: PORT)
end
