describe CreateArticleService do
  describe '.call' do
    it 'creates article' do
      service = described_class.new(title: 'Title', content: 'Content')
      result = nil

      expect { result = service.call }.to change(Article, :count).from(0).to(1)
      expect(result).to be true
      expect(service.errors).to be_blank
      expect(service.article.title).to eq 'Title'
      expect(service.article.content).to eq 'Content'
    end

    it "returns false if article's title is nil" do
      service = described_class.new(title: nil, content: 'Content')
      result = nil

      expect { result = service.call }.not_to change(Article, :count)
      expect(result).to be false
      expect(service.errors).to be_present
    end

    it "returns false if article's title is not unique" do
      create(:article, title: 'Title')
      service = described_class.new(title: 'Title', content: 'Content')
      result = nil

      expect { result = service.call }.not_to change(Article, :count)
      expect(result).to be false
      expect(service.errors).to be_present
    end

    it 'notifies slack channel after creating article' do
      slack_wrapper_double = instance_double(SlackWrapper, send_message!: nil)
      allow(SlackWrapper).to receive(:new).and_return(slack_wrapper_double)
      service = described_class.new(title: 'Title', content: 'Content')

      result = nil

      expect do
        result = service.call
      end.to change(ArticleCreationSlackNotificationJob.jobs, :count).by(1)
      expect(result).to be true
    end
  end
end
