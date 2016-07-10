require 'bundler/setup'
Bundler.require

class Application < Sinatra::Base
  README = Qiita::Markdown::Processor.new.call(File.read('README.md'))[:output].freeze

  get '/' do
    %{
    <title>Qiita Markdown Server</title>
    <style>body{box-sizing:border-box;min-width:200px;max-width:980px;margin:0 auto;padding:45px;}</style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/github-markdown-css/2.3.0/github-markdown.css">
    <article class="markdown-body">#{README}</article>
    }
  end

  post '/markdown' do
    begin
      input = JSON.parse(request.body.read, symbolize_names: true)
      unless input.key?(:text)
        client_error("`text` key is missing")
      else
        options = input[:options] || {}
        begin
          processor = Qiita::Markdown::Processor.new(options)
          result = processor.call(input[:text])
          content_type :json, 'charset' => 'utf-8'
          result.to_json
        rescue
          client_error("Processing markdown failed")
        end
      end
    rescue
      client_error("Malformed json")
    end
  end

  private

  def client_error(message)
    error(400, message)
  end

  def error(code, message)
    status code
    content_type :json, 'charset' => 'utf-8'
    JSON.pretty_generate({message: message})
  end
end
