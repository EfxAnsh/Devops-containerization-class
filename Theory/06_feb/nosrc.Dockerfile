FROM python
WORKDIR /home
RUN pip install numpy
CMD ["python","./app.py"]