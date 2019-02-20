require 'spec_helper'

describe Streakable do
  let(:user) { User.create }

  let!(:posts) do
    post_dates.each do |date|
      user.posts.create(created_at: date)
    end
  end
  let(:post_dates) { [] }

  describe "#streak" do
    subject { user.streak(:posts) }

    context "user has no posts" do
      before { expect(user.posts).to be_empty }
      it { is_expected.to be 0 }
    end

    context "user posted on each of the last three days" do
      let(:post_dates) { [2.days.ago, 1.day.ago, DateTime.current] }

      it "returns the streak" do
        expect(subject).to eq(posts.size)
      end
    end

    context "user only has a post today" do
      let(:post_dates) { [DateTime.current] }
      before do
        expect(user.posts.length).to eql(1)
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

    context "user has streak today, and a shorter streak before that" do
      let(:post_dates) { [5.days.ago, 4.days.ago, 2.days.ago, 1.day.ago, DateTime.current] }

      it "still returns the current streak" do
        expect(subject).to eq(3)
      end

      context "with longest option" do
        subject { user.streak(:posts, longest: true) }

        it "still returns the longer streak" do
          expect(subject).to eq(3)
        end
      end
    end

    context "user didn't post today, but has a streak before that" do
      let(:post_dates) { [3.days.ago, 2.day.ago, 1.day.ago] }
      before { expect(post_dates.map(&:to_date)).to_not include(Date.current) }

      it "returns streak of zero" do
        expect(subject).to eq(0)
      end

      context "except today" do
        subject { user.streak(:posts, except_today: true) }

        it "returns the streak" do
          expect(subject).to eq(post_dates.size)
        end
      end

      context "but has three streaks, longest in the middle" do
        let(:post_dates) { [3.days.ago, 4.days.ago, 6.days.ago, 7.days.ago, 8.days.ago, 10.days.ago, 11.days.ago] }

        it "returns 0" do
          expect(subject).to eq(0)
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

  describe "#streaks" do
    subject { user.streaks(:posts) }

    context "user has no posts" do
      before { expect(user.posts).to be_empty }
      it { is_expected.to eql([]) }
    end

    context "user posted on each of the last two days" do
      let(:post_dates) { [1.day.ago, DateTime.current] }

      it "returns the streak" do
        expect(subject).to eq([[Date.current, 1.day.ago.to_date]])
      end
    end

    context "user posted on each of the last three days" do
      let(:post_dates) { [2.days.ago, 1.day.ago, DateTime.current] }

      it "returns the streak" do
        expect(subject).to eq([[Date.current, 1.day.ago.to_date, 2.days.ago.to_date]])
      end
    end

    context "user only has a post today" do
      let(:post_dates) { [DateTime.current] }
      before do
        expect(user.posts.length).to eql(1)
        expect(user.posts.first.created_at.to_date).to eql(Date.current)
      end

      it "returns the streak of 1" do
        expect(subject).to eq([[Date.current]])
      end
    end

    context "user only has a post yesterday" do
      let(:post_dates) { [DateTime.current.yesterday] }
      before do
        expect(user.posts.length).to eql(1)
        expect(user.posts.first.created_at.to_date).to eql(Date.current.yesterday)
      end

      it "returns the streak of 1" do
        expect(subject).to eq([[Date.current.yesterday]])
      end
    end

    context "user has streak today, and a longer streak before that" do
      let(:post_dates) { [DateTime.current, 1.day.ago, 3.days.ago, 4.days.ago, 5.days.ago] }

      it "returns the streaks" do
        expected = [[Date.current, 1.day.ago], [3.days.ago, 4.days.ago, 5.days.ago]].map do |x|
          x.map(&:to_date)
        end

        expect(subject).to eq(expected)
      end
    end

    context "user didn't post today, but has a streak of 3 before that" do
      let(:post_dates) { [1.days.ago, 2.days.ago, 3.day.ago] }

      it "returns the streak" do
        expected = [[1.day.ago, 2.days.ago, 3.days.ago]].map do |x|
          x.map(&:to_date)
        end

        expect(subject).to eq(expected)
      end
    end

    context "user has three streaks, longest in the middle" do
      let(:post_dates) { [3.days.ago, 4.days.ago, 6.days.ago, 7.days.ago, 8.days.ago, 10.days.ago, 11.days.ago] }

      it "returns the streaks" do
        expected = [[3.days.ago, 4.days.ago], [6.days.ago, 7.days.ago, 8.days.ago], [10.days.ago, 11.days.ago]].map do |x|
          x.map(&:to_date)
        end

        expect(subject).to eq(expected)
      end
    end
  end
end
