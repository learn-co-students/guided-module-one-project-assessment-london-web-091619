class Api
    require 'open-uri'
    def topheadlines
        url = 'https://newsapi.org/v2/top-headlines?'\
        'country=gb&'\
        'apiKey=a6ab0f0401f84dd8a258bec777a35885'
        request = open(url)
        response_body = JSON.parse(request.read)["articles"]
    end 


    def formatdata
        topheadlines.map{|article| {title: article["title"], content: article["content"]}}
    end
end