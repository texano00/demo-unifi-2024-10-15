#!/bin/bash
yum update -y
yum install python3 -y

curl https://bootstrap.pypa.io/get-pip.py | python3

pip3 install boto3 flask gunicorn

# Create the application directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

wget -O https://raw.githubusercontent.com/texano00/demo-unifi-2024-10-15/refs/heads/main/IaaS/02-terraform/source/main.py main.py


# # Create the Flask app
# cat <<EOF2 > /home/ec2-user/app/main.py
# from flask import Flask, request, jsonify
# import boto3

# app = Flask(__name__)

# dynamodb = boto3.resource('dynamodb')
# table_name = "${tableName}"
# table = dynamodb.Table(table_name)

# @app.route('/create', methods=['POST'])
# def create_item():
#     item = request.json
#     table.put_item(Item=item)
#     return jsonify({"message": f"Item {item['id']} created."}), 201

# @app.route('/read/<string:item_id>', methods=['GET'])
# def read_item(item_id):
#     response = table.get_item(Key={'id': item_id})
#     item = response.get('Item', None)
#     if item:
#         return jsonify(item), 200
#     else:
#         return jsonify({"message": f"Item {item_id} not found."}), 404

# @app.route('/update/<string:item_id>', methods=['PUT'])
# def update_item(item_id):
#     update_data = request.json
#     update_expression = "SET " + ", ".join([f"#{k} = :{k}" for k in update_data])
#     expression_attribute_names = {f"#{k}": k for k in update_data}
#     expression_attribute_values = {f":{k}": v for k, v in update_data.items()}

#     table.update_item(
#         Key={'id': item_id},
#         UpdateExpression=update_expression,
#         ExpressionAttributeNames=expression_attribute_names,
#         ExpressionAttributeValues=expression_attribute_values
#     )
#     return jsonify({"message": f"Item {item_id} updated."}), 200

# @app.route('/delete/<string:item_id>', methods=['DELETE'])
# def delete_item(item_id):
#     table.delete_item(Key={'id': item_id})
#     return jsonify({"message": f"Item {item_id} deleted."}), 200

# @app.route('/', methods=['GET'])
# def health_check():
#     return jsonify({"message": "Server is running"}), 200

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)
# EOF2

# Start Gunicorn to serve the Flask app
export AWS_DEFAULT_REGION=eu-central-1
export FLASK_RUN_HOST=0.0.0.0
gunicorn -w 15 -b 0.0.0.0:5000 main:app --daemon