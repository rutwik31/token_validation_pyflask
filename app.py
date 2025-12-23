from flask import Flask, request
from os import getenv
from dotenv import load_dotenv
from pymssql import connect

load_dotenv()

app = Flask(__name__)


def get_db_connection():
    return connect(
        server=getenv("SQL_SERVER"),
        user=getenv("SQL_USER"),
        password=getenv("SQL_PASSWORD"),
        database=getenv("SQ`L_DATABASE"),
    )


@app.route("/")
def hello():
    token = request.args.get("token")
    if not token:
        return "", 204

    conn = get_db_connection()
    cursor = None
    try:
        cursor = conn.cursor()
        cursor.execute(
            "SELECT max_count, counter FROM tokens WHERE token = %s",
            (token,)
        )
        row = cursor.fetchone()

        if not row:
            return "", 204

        max_count, counter = row
        counter += 1

        cursor.execute(
            "UPDATE tokens SET counter = %s WHERE token = %s",
            (counter, token)
        )
        conn.commit()

        if counter <= max_count:
            return f"Hello World! Counter = {counter}"

        return "", 204
    finally:
        if cursor:
            cursor.close()
        conn.close()


if __name__ == "__main__":
    app.run(debug=True)


