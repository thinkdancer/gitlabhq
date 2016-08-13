require 'spec_helper'

describe Banzai::Filter::ImageLinkFilter, lib: true do
  include FilterSpecHelper

  def image(path)
    %(<img src="#{path}" />)
  end

  it 'wraps the image with a link to the image src' do
    doc = filter(image('/uploads/e90decf88d8f96fe9e1389afc2e4a91f/test.jpg'))
    expect(doc.at_css('img')['src']).to eq doc.at_css('a')['href']
  end

  it 'does not wrap a duplicate link' do
    exp = act = %q(<a href="/whatever">#{image('/uploads/e90decf88d8f96fe9e1389afc2e4a91f/test.jpg')}</a>)
    expect(filter(act).to_html).to eq exp
  end

  it 'works with external images' do
    doc = filter(image('https://i.imgur.com/DfssX9C.jpg'))
    expect(doc.at_css('img')['src']).to eq doc.at_css('a')['href']
  end

  it 'works with inline images' do
    doc = filter(%Q(<p>test #{image('/uploads/e90decf88d8f96fe9e1389afc2e4a91f/test.jpg')} inline</p>))
    expect(doc.to_html).to match /^<p>test <a[^>]*><img[^>]*><\/a> inline<\/p>$/
  end
end
