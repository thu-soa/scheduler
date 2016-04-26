require './main'
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