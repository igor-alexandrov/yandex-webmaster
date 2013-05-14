# encoding: utf-8

require 'helper'

describe Yandex::Webmaster do

  it { should respond_to :new }

  it { expect(subject.new).to be_a Yandex::Webmaster::Client }

end