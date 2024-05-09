#Docker mai ek python image choose karenge So Alpine is a lightweight version of Linux, and it's ideal for running Docker containers because it is very stripped back. It doesn't have any unnecessary dependencies that you would need. Everything that it comes with is just the bare minimum and it's an extremely lightweight and efficient image to use for Docker. So that's why I like to use the Alpine image.
FROM python:3.9-alpine3.13

#basically whoever is going to be maintaining this Docker image, apna naam khle
LABEL maintainer="londonappdeveloper.com"

#it tells Python that you don't want to buffer the output(temporarily storing output before sending it to a destination). The output from Python will be printed directly to the console, which prevents any delays of messages getting from our Python running application to the screen so we can see the logs immediately in the screen as they're running.
ENV PYTHONUNBUFFERED 1

#it says copy our requirements on text file from our local machine to /tmp/requirements. txt in Docker container,it will install all req.
COPY ./requirements.txt /tmp/requirements.txt


COPY ./requirements.dev.txt /tmp/requirements.dev.txt

#copy app directory that's going to contain our Django app and we copy it to forward slash app inside the container.
COPY ./app /app

#working directory is the default directory jaha se command run karenge docker mai,so we set it as app directory ,app se command run ho by default,baar baar location ni likhna.
WORKDIR /app

#to expose Port 8000 from our container to our machine when we run the container.it allows us to access that port on the container that's running from our image. And this way we can connect to the Django Development Server.
EXPOSE 8000

ARG DEV=false

#alag alag run command ko ek run mai run karne ke liye &&\ merge kiya , to keep our images as lightweight as possible.
#1rst venv command is used to create virtual env where we will store our dependencies,2nd UPGRADE python installer package,
#3rd /ye requirements.txt file 11th line mai (upparhai) cointainer mai laee thee ,uske andar ki saari chizo ko pip(start mai pip ki location) ki help se install karenge. 
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
#uppar if statement of end ke liye fi niche line temp folder ko delete kyunki ab tmp folder req ni hai kyuki saari dependencies install Karli hai    
    rm -rf /tmp && \
#creating new user by default we have root user, we create new user and disabled password for him
#We don't want people to be able to log on to our container using a password,django-user name hai user ka    
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

#path to virtual environment,har command virtual env se by default chale
ENV PATH="/py/bin:$PATH"

#we switch to new user(Django-user) from root user.
USER django-user 