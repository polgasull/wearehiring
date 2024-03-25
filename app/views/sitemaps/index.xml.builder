xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.tag! 'urlset',
    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
    'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd http://www.w3.org/1999/xhtml http://www.w3.org/2002/08/xhtml/xhtml1-strict.xsd',
    'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
    'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml' do

  xml.tag! 'url' do
    xml.tag! 'loc', root_en_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', talent_how_it_works_en_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', companies_how_it_works_en_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', about_us_en_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', pricing_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', blog_posts_url
  end

  @jobs.each do |job|
    xml.tag! 'url' do
      xml.tag! 'loc', job_en_url(job)
      xml.lastmod job.updated_at.strftime("%F")
    end
  end

  @posts.each do |post|
    xml.tag! 'url' do
      xml.tag! 'loc', blog_post_url(post)
      xml.lastmod post.updated_at.strftime("%F")
    end
  end
end
