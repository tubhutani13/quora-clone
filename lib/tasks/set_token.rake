namespace :question do
  desc "Question"
  task create_token: :environment do
    Question.where(permalink: nil) do
      question.generate_token(:permalink)
      question.save
    end
    p "done"
  end
end
