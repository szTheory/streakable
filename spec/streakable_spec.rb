require 'spec_helper'

describe Streakable do
  describe "#streak" do
    subject { user.streak(:posts) }

    let(:user) { User.create }

    context "when a user has no posts" do
      before { expect(user.posts).to be_empty }
      it { is_expected.to be 0 }
    end

    let!(:posts) do
      post_dates.each do |date|
        user.posts.create(created_at: date)
      end
    end
    let(:post_dates) { [] }

    context "when a user posted on each of the last three days" do
      let(:post_dates) { [2.days.ago, 1.day.ago, DateTime.current] }

      it "returns the streak" do
        expect(subject).to eq(posts.size)
      end
    end

    context "when a user didn't post today" do
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
