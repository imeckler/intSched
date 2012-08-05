map_ = !(f, xs) -->
  for x in xs
    f x

whenClient = (f) -> if Meteor.is_client then f!

log = -> console.log arguments