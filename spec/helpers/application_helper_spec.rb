require 'rails_helper'

describe ApplicationHelper do
    context "the return of full_title" do
      it { expect(full_title("foo")).to include("foo") }
      it { expect(full_title("foo")).to include("Simple Address Book") }
      it { expect(full_title("foo")).to eq("Simple Address Book | foo") }
    end

    context "the return of full_title" do
      it { expect(full_title("")).not_to include("|") }
      it { expect(full_title("")).to eq("Simple Address Book") }
    end
end
