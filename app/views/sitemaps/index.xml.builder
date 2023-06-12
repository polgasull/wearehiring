xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.tag! 'urlset',
    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
    'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd http://www.w3.org/1999/xhtml http://www.w3.org/2002/08/xhtml/xhtml1-strict.xsd',
    'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
    'xmlns:xhtml' => 'http://www.w3.org/TR/xhtml11/xhtml11_schema.html' do

  xml.tag! 'url' do
    xml.tag! 'loc', root_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', talent_how_it_works_url
    xml.tag! 'xhtml:link', rel: 'alternate', hreflang: 'es', href: talent_how_it_works_es_url
    xml.tag! 'xhtml:link', rel: 'alternate', hreflang: 'en', href: talent_how_it_works_en_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', companies_how_it_works_url
    xml.tag! 'xhtml:link', rel: 'alternate', hreflang: 'es', href: companies_how_it_works_es_url
    xml.tag! 'xhtml:link', rel: 'alternate', hreflang: 'en', href: companies_how_it_works_en_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', pricing_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', blog_posts_url
  end
  
  @jobs.each do |job|
    xml.tag! 'url' do
      xml.tag! 'loc', job_url(job)
      xml.lastmod job.updated_at.strftime("%F")
      xml.tag! 'xhtml:link', rel: 'alternate', hreflang: 'es', href: job_es_url(job)
      xml.tag! 'xhtml:link', rel: 'alternate', hreflang: 'en', href: job_en_url(job)  
    end
  end

  @posts.each do |post|
    xml.tag! 'url' do
      xml.tag! 'loc', blog_post_url(post)
      xml.lastmod post.updated_at.strftime("%F")
    end
  end

end