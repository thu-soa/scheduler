require './main'

User.create(name: 'learn', user_type: :source)
User.create(name: 'alexwang', user_type: :user)

10.times do |x|
  Message.create(
      title:   "Awesome Message ##{x}",
      user_id: 1,
      msg_type:'notification',
      source:  'mail',
      url:     'https://blog.a1ex.wang',
      description: 'empty'
  )
end