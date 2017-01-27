
Resources:

Heroku: whimsy-dumper
S3: whimsyspace-databucket-1g3p6d9lcl6x1

Test slurp content from url:

    curl \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: 203801d5-19a7-43a0-a03b-96e9f6282c2d" \
    -d '{"url": "http://google.com"}' \
    http://locohost:3000/slurp


Heroku Trix:

Reset Rails Postgres Database on Heroku:

> The rake db:reset task is not supported. Heroku apps do not have permission to drop and create databases. Use the heroku pg:reset command instead.

AWS Cheat Sheet:

US Standard is us-east-1

[S3 Put Object from Ruby](https://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method)
