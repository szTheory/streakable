require 'spec_helper'

describe Streakable do
  describe "#streak" do
    subject { user.streak(:posts) }

    let(:user) { User.create }

    context "user has no posts" do
      before { expect(user.posts).to be_empty }
      it { is_expected.to be 0 }
    end

    let!(:posts) do
      post_dates.each do |date|
        user.posts.create(created_at: date)
      end
    end
    let(:post_dates) { [] }

    context "user posted on each of the last three days" do
      let(:post_dates) { [2.days.ago, 1.day.ago, DateTime.current] }

      it "returns the streak" do
        expect(subject).to eq(posts.size)
      end
    end

    context "user only has a post today" do
      let(:post_dates) { [DateTime.current] }
      before do
        expect(user.posts.size).to eql(1)
        expect(user.posts.first.created_at.to_date).to eql(Date.current)
      end

      it "returns the streak of 1" do
        expect(subject).to eq(1)
      end
    end

    context "user has streak today, and a longer streak before that" do
      let(:post_dates) { [5.days.ago, 4.days.ago, 3.days.ago, 1.day.ago, DateTime.current] }

      it "still returns the current streak" do
        expect(subject).to eq(2)
      end

      context "with longest option" do
        subject { user.streak(:posts, longest: true) }

        it "returns the longer streak" do
          expect(subject).to eq(3)
        end
      end
    end

    context "user didn't post today" do
      let(:post_dates) { [3.days.ago, 2.day.ago, 1.day.ago] }

      it "returns streak of zero" do
        expect(subject).to eq(0)
      end

      context "except today" do
        subject { user.streak(:posts, except_today: true) }

        it "returns the streak" do
          expect(subject).to eq(post_dates.size)
        end
      end
    end

    context "spanning two months" do
      around do |example|
        Timecop.freeze(DateTime.current.beginning_of_month) do
          example.run
        end
      end
      let(:post_dates) { [1.day.ago, DateTime.current] }

      it "returns a streak of 2" do
        expect(subject).to eq(2)
      end
    end
  end
end
