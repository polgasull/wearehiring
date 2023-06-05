xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.tag! 'url' do
    xml.tag! 'loc', root_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', jobs_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', how_it_works_talent_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', how_it_works_companies_url
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
    end
  end

  @posts.each do |post|
    xml.tag! 'url' do
      xml.tag! 'loc', blog_post_url(post)
      xml.lastmod post.updated_at.strftime("%F")
    end
  end

end