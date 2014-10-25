require 'spec_helper'

describe BootstrapLinkRenderer do
  let(:link_renderer) { BootstrapLinkRenderer.new }

  describe "#page_number" do
    before do
      allow(link_renderer).to receive(:current_page).and_return(page)
      allow(link_renderer).to receive(:rel_value).and_return('nofollow')
    end
    subject { link_renderer.send(:page_number, page) }
    let(:page) { double('Page') }

    it "should generate an li to contain the link or text" do
      expect(subject).to match(/^<li/)
    end

    it "should generate a link in the li" do
      allow(link_renderer).to receive(:current_page).and_return("not the page")
      expect(subject).to match(/<a /)
    end
    it "should put the class 'active' on the li if this is the current page" do
      expect(subject).to match(/<li class="active"><a /)
    end
  end

  describe "#previous_or_next_page" do
    subject { link_renderer.send(:previous_or_next_page, page, text, class_name) }
    let(:page) { double('Page') }
    let(:text) { 'prev' }
    let(:class_name) { 'previous_page' }

    it "should generate an li to contain the link or text" do
      expect(subject).to match(/^<li/)
    end

    it "should generate a link in the li" do
      allow(link_renderer).to receive(:current_page).and_return("not the page")
      expect(subject).to match(/<a /)
    end

    it "should add the class 'disabled' to the li if the page is nil" do
      expect(link_renderer.send(:previous_or_next_page, nil, text, class_name)).to match(/<li class="prev previous_page disabled"/)
    end
  end

  describe "#html_container" do
    before do
      allow(link_renderer).to receive(:container_attributes).and_return({'class' => "pagination"})
    end
    subject { link_renderer.send(:html_container, 'some html') }

    it "should render a ul" do
      expect(subject).to match(/<ul/)
    end
  end

  describe "#gap" do
    subject { link_renderer.send(:gap) }
    let(:gap_text) { "..." }
    let(:template) { double('template', :will_paginate_translate => gap_text) }

    before do
      link_renderer.prepare([], {}, template)
    end

    it "should render the gap .. within an li" do
      expect(subject).to match(/<span class="gap">#{gap_text}<\/span>/)
    end

  end

end
