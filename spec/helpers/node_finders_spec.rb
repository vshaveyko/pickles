require 'spec_helper'

RSpec.describe '#NodeFinders', :Helpers, :NodeFinders do

  # let(:finder) { Object.new.extend(NodeFinders) }
  # let(:stub) { Object.new }

  describe '#find_node', :find_node do

    before(:each) { @session.visit('/with_html') }

    it 'raises ambgious error' do
      expect { Pickles.find_node('A link') }.to raise_error(Pickles::Ambiguous)
    end

    it 'Finds element with exact text with = ' do
      expect(Pickles.find_node('=A link')).to have_attributes path: "/html/body/p[3]/a[3]"
    end

    it 'Finds element by index with [1]' do
      expect(Pickles.find_node('A link[1]')).to have_attributes path: "/html/body/p[3]/a[2]"
    end

  end

  describe '#find_input', :find_input do

    class TestApp

      get '/with/inputs' do
        <<~HTML
          <!-- Case1 -->
          <div> <div> <span>LABEL_INPUT</span> </div>
            <input type="text" value="LABEL_INPUT_VALUE" />
          </div>

          <!-- Case2 -->
          <input type="text" placeholder="PLACEHOLDER_INPUT" value="PLACEHOLDER_INPUT_VALUE" />

          <!-- Case3 -->
          <div> <div> <span>TEXTAREA_LABEL</span> </div>
            <textarea>TEXTAREA_VALUE</textarea>
          </div>

          <!-- Case4 -->
          <div contenteditable="true" placeholder="CONTENTEDITABLE_PLACEHOLDER">
            CONTENTEDITABLE_PLACEHOLDER_VALUE
          </div>

          <!-- Case5 -->
          <div> <div> <span>CONTENTEDITABLE_LABEL</span> </div>
            <div contenteditable="true">
              CONTENTEDITABLE_LABEL_VALUE
            </div>
          </div>
        HTML
      end

    end

    before(:each) { @session.visit('/with/inputs') }

    describe 'input' do
      it 'by span label' do
        expect(
          Pickles.find_input('LABEL_INPUT')
        ).to have_attributes value: "LABEL_INPUT_VALUE"
      end

      it 'by placeholder' do
        expect(
          Pickles.find_input('PLACEHOLDER_INPUT')
        ).to have_attributes value: "PLACEHOLDER_INPUT_VALUE"
      end
    end

    describe 'textarea' do
      it 'by span label' do
        expect(
          Pickles.find_input('TEXTAREA_LABEL')
        ).to have_attributes value: "TEXTAREA_VALUE"
      end
    end

    describe 'contenteditable' do
      it 'by placeholder' do
        expect(
          Pickles.find_input('CONTENTEDITABLE_PLACEHOLDER')
        ).to have_attributes text: "CONTENTEDITABLE_PLACEHOLDER_VALUE"
      end

      it 'by span label' do
        expect(
          Pickles.find_input('CONTENTEDITABLE_LABEL')
        ).to have_attributes text: "CONTENTEDITABLE_LABEL_VALUE"
      end
    end

  end

  describe '#detect_node', :detect_node do

    class TestApp

      get '/with/divs' do
        <<~HTML
          <!-- Case1 -->
          <div class="TEST_CLASS">TEST_CLASS_VALUE</div>

          <!-- Case2 -->
          <div> <div id="TEST_ID">TEST_ID_VALUE</div> </div>

          <!-- Case3 -->
          <custom-tag>CUSTOM_TAG_VALUE[1]</custom-tag>
          <custom-tag>CUSTOM_TAG_VALUE[2]</custom-tag>
        HTML
      end

    end

    before(:each) { @session.visit('/with/divs') }

    it 'finds by xpath_node_map' do
      Pickles.configure do |c|
        c.xpath_node_map = {
          xpath_test_node: "//div[@id='TEST_ID']"
        }
      end

      expect(
        Pickles.detect_node(:xpath_test_node)
      ).to have_attributes text: 'TEST_ID_VALUE'
    end

    it 'finds by css_node_map' do
      Pickles.configure do |c|
        c.css_node_map = {
          css_test_node: ".TEST_CLASS"
        }
      end

      expect(
        Pickles.detect_node(:css_test_node)
      ).to have_attributes text: 'TEST_CLASS_VALUE'
    end

    it 'fallbacks to given value as css tag' do
      expect(
        Pickles.detect_node('custom-tag[1]')
      ).to have_attributes text: 'CUSTOM_TAG_VALUE[1]'
    end

  end

end
