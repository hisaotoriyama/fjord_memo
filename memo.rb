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

post '/' do
  todo = params['todo']
  detail = params['detail']
  add_new(todo, detail)
  redirect '/'
end

get '/show/:id' do
  id = params['id'].to_i
  @content = read_selected(id)
  erb :show
end

get '/edit/:id' do
  @id = params['id']
  @todo = params['todo']
  @detail = params['detail']
  erb :edit
end

patch '/' do
  id = params['id'].to_i
  todo = params['todo']
  detail = params['detail']
  update_selected(id, todo, detail)
  redirect '/'
end

delete '/:id' do
  id = params['id'].to_i
  delete_selected(id)
  redirect '/'
end

get '/layout' do
  erb :layout
end

def read_all
  results = db_connect.exec('SELECT * FROM memo_table;')
  convert_memodata(results)
end

def read_selected(id)
  results = db_connect.exec('SELECT * FROM memo_table WHERE id = $1', [id])
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

def delete_selected(id)
  db_connect.exec('DELETE FROM memo_table WHERE id = $1', [id])
end

def update_selected(id, todo, detail)
  db_connect.exec('UPDATE memo_table SET todo =$2, detail = $3 WHERE id = $1', [id, todo, detail])
end

def add_new(todo, detail)
  db_connect.exec('INSERT INTO memo_table (todo, detail) VALUES ($1,$2)', [todo, detail])
end

DB = 'memodb'
PORT = '5432'
def db_connect
  PG.connect(dbname: DB, port: PORT)
end
