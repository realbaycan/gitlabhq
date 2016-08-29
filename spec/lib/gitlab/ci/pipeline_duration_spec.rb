require 'spec_helper'

describe Gitlab::Ci::PipelineDuration do
  let(:calculator) { create_calculator(data) }

  shared_examples 'calculating duration' do
    it do
      expect(calculator.duration).to eq(duration)
      expect(calculator.pending_duration).to eq(pending_duration)
    end
  end

  context 'test sample A' do
    let(:data) do
      [[0, 1],
       [1, 2],
       [3, 4],
       [5, 6]]
    end

    let(:duration) { 4 }
    let(:pending_duration) { 2 }

    it_behaves_like 'calculating duration'
  end

  context 'test sample B' do
    let(:data) do
      [[0, 1],
       [1, 2],
       [2, 3],
       [3, 4],
       [0, 4]]
    end

    let(:duration) { 4 }
    let(:pending_duration) { 0 }

    it_behaves_like 'calculating duration'
  end

  context 'test sample C' do
    let(:data) do
      [[0, 4],
       [2, 6],
       [5, 7],
       [8, 9]]
    end

    let(:duration) { 8 }
    let(:pending_duration) { 1 }

    it_behaves_like 'calculating duration'
  end

  context 'test sample D' do
    let(:data) do
      [[0, 1],
       [2, 3],
       [4, 5],
       [6, 7]]
    end

    let(:duration) { 4 }
    let(:pending_duration) { 3 }

    it_behaves_like 'calculating duration'
  end

  context 'test sample E' do
    let(:data) do
      [[0, 1],
       [3, 9],
       [3, 4],
       [3, 5],
       [3, 8],
       [4, 5],
       [4, 7],
       [5, 8]]
    end

    let(:duration) { 7 }
    let(:pending_duration) { 2 }

    it_behaves_like 'calculating duration'
  end

  def create_calculator(data)
    segments = data.shuffle.map do |(first, last)|
      Gitlab::Ci::PipelineDuration::Segment.new(first, last)
    end

    Gitlab::Ci::PipelineDuration.new(segments)
  end
end
