xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.tag! 'url' do
    xml.tag! 'loc', root_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', jobs_url
  end

  xml.tag! 'url' do
    xml.tag! 'loc', new_job_url
  end

  @jobs.each do |job|
    xml.tag! 'url' do
      xml.tag! 'loc', jobs_url(job)
      xml.lastmod job.updated_at.strftime("%F")
    end
  end

end