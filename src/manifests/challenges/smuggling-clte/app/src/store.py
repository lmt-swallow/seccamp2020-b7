import os

class NotFound(Exception):
    pass

class LocalStore:
    def __init__(self):
        import tempfile
        self.upload_directory = tempfile.mkdtemp()

    def read(self, key):
        filepath = os.path.join(self.upload_directory, key)

        try:
            with open(filepath, "rb") as fp:
                return fp.read()
        except FileNotFoundError:
            raise NotFound

    def save(self, key, data):
        with open(os.path.join(self.upload_directory, key), "wb") as fp:
            fp.write(data)