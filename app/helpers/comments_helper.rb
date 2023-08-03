module CommentsHelper
    def comment_custom_path(comment,entity,question)
        if comment.commentable_type == 'Question'
            question_comment_path(entity.permalink,comment)
        elsif comment.commentable_type == 'Answer'
            question_answer_comment_path(question.permalink,entity.id,comment)
        end 
    end

end
