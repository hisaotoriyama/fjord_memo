# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'json'

get '/' do
  @file_contents = read_file('memo.json')
  erb :top
end

get '/new' do
  erb :new
end

post '/create' do
  @file_contents = read_file('memo.json')
  new_id = if @file_contents == []
             1
           else
             @file_contents.last['id'] + 1
           end
  @file_contents << { "id": new_id, "todo": params['todo'], "detail": params['detail'] }
  write_file(@file_contents, 'memo.json')
  redirect '/'
end

get '/show/:id' do
  @file_contents = read_file('memo.json')
  @selected_content = @file_contents.select do |content|
    content['id'] == params['id'].to_i
  end
  @selected_content = @selected_content[0]
  erb :show
end

get '/edit/:id' do
  @id = params['id']
  @todo = params['todo']
  @detail = params['detail']
  erb :edit
end

patch '/' do
  @file_contents = read_file('memo.json')
  @selected_content = @file_contents.select do |content|
    content['id'] == params['id'].to_i
  end
  @selected_content = @selected_content[0]
  @selected_content['todo'] = params['todo']
  @selected_content['detail'] = params['detail']
  @id = params['id'].to_i
  @file_contents[@id - 1] = @selected_content
  write_file(@file_contents, 'memo.json')
  redirect '/'
end

delete '/delete/:id' do
  @file_contents = read_file('memo.json')
  @selected_contents = @file_contents.reject do |content|
    content['id'] == params['id'].to_i
  end
  write_file(@selected_contents, 'memo.json')
  redirect '/'
end

get '/layout' do
  erb :layout
end

def read_file(json_file)
  File.open(json_file) do |file|
    JSON.load(file)
  end
end

def write_file(file_contents, file)
  File.open(file, 'w') do |f|
    JSON.dump(file_contents, f)
  end
end
