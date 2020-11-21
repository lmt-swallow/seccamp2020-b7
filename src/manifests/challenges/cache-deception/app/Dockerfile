FROM python:3.8.2-alpine3.10

WORKDIR /app
COPY ./ /app
RUN pip install -r requirements.txt

CMD ["python", "app.py"]