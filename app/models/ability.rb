class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote, Subscription]
    can :update, [Question, Answer, Comment, Vote], user: user
    can :destroy, [Question, Comment], user: user
    can :destroy, Attachment, attachmentable: { user: user }
    can :mark_best, Answer do |answer|
      answer.question.user == user
    end
  end

end
