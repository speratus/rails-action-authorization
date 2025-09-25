[![Test Gem](https://github.com/speratus/rails-action-authorization/actions/workflows/ruby-tests.yml/badge.svg)](https://github.com/speratus/rails-action-authorization/actions/workflows/ruby-tests.yml)
[![codecov](https://codecov.io/gh/speratus/rails-action-authorization/branch/master/graph/badge.svg)](https://codecov.io/gh/speratus/rails-action-authorization)
[![Maintainability](https://api.codeclimate.com/v1/badges/588fbef9d8a7c39bb071/maintainability)](https://codeclimate.com/github/speratus/authorizer/maintainability)

# Rails Action Authorization
Rails Action Authorization is a rails plugin that gives developers a lightweight authorization framework.

While there are lots of rails plugins designed to do authorization, Rails Action Authorization strives to 
be the most intuitive while simultaneously allowing developers to write the smallest possible amount of code to have a functioning authorization system.

## Usage
There are two parts to using `rails-action-authorization`. The first part is defining rules.
Rules are defined on models, and they specify how actions determine how to authorize users (or other models).

The second parrt of using `rails-action-authorization` is on the controller side. In any action in which authorization is required, run the `check_authorization` method.

### Step One, defining rules
Suppose we are writing the proverbial blogging application, and we need some way to determine whether a user is permitted to edit a post.

The first step is to define a rule for the action that will need authorization. In our case, we'll need authorization for the `edit` and `update` actions. To define a rule, we'll have to edit our `Post` model.
```ruby
# models/Post.rb

class Post < ApplicationRecord
    ...
end
```

Rules are defined using the `define_rule` method. `define_rule` takes at least one argument that is a string or a symbol that represents the action that needs authorization in the format `controller#action`. In our case, we need to authorize the `edit` and `update` actions like so:
```ruby
# models/Post.rb
class Post < ApplicationRecord
    ...
    define_rule 'posts#edit', 'posts#update' do |post, user|
        # Authorization code here
    end
end
```

`define_rule` can take as many arguments as desired, enabling developers to define authorization rules for multiple actions simultaneously. 

The block must return `true` or `false`, `true` if the user is permitted to edit the post 
and `false` if the user is not permitted. The block itself will always yield the resource
that is being authorized as the first argument and the actor requesting authorization as the second argument. The first argument should always be the type as the class in which `define_rule` is called (if you ever encounter a case where it is not, then please report it as a bug). The second argument could technically be any model, but will probably most often be a `User` instance.

Since we only want a post's author to be able to edit a post, we'll define our rule as follows:
```ruby
# models/Post.rb
class Post < ApplicationRecord
    ...
    define_rule 'posts#edit', 'posts#update' do |post, user|
        post.author == user
    end
end
```

Next, we have to check the authorization of the user in each controller. The only thing required
to do this is to invoke `check_authorization` somewhere in each action that requries authorization.
```ruby
# controllers/posts_controller.rb
class PostsController < ApplicationController
    before_action :authorize_user, only: [:edit, :update]

    ...

    def edit
        ...
        #You will be able to reference @post in your views as usuals.
    end

    def update
        ...
    end

    private

    def authorize_user
        @post = check_authorization(Post.find_by(id: params[:id]), current_user) # Here, use your own method for getting the current user.

    end
end
```
Notice that we are able to call check_authorization in a `before_action`. This is because `check_authorization`
knows how to identify the action it is called in without requiring developers to specify it themselves.

This will work great when the owner tries to edit his own posts, but if another user attempts to edit
a post, the server will raise an error. `rails-action-authorization` raises a `ForbiddenError` if a
user fails to be authorized in order to eliminate potential ambiguity of returning nil or some other
value.

In order to handle authorization failures, we'll have to adapt our controller slightly:
```ruby
# controllers/posts_controller.rb
class PostsController < ApplicationController
    before_action :authorize_user, only: [:edit, :update]
    rescue_from ActionAuthorization::ForbiddenError, with:
        :handle_forbidden

    ...

    def edit
        ...
        #You will be able to reference @post in your views as usuals.
    end

    def update
        ...
    end

    private

    def authorize_user
        @post = check_authorization(Post.find_by(id: params[:id]), current_user) # Here, use your own method for getting the current user.
    end

    def handle_forbidden
        render '403', status: 403
    end
end
```
This will cause the execution of any action to cease immediately when a user fails to authorize, and
instead run the code in `handle_forbidden`.

Of course, the above example assumes that you have a template for a `403` error, but you can run
whatever code is necessary in your case. 

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails-action-authorization'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails-action-authorization
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
