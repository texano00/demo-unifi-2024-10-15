from flask import Flask, request, jsonify
import boto3
import os

app = Flask(__name__)

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE_NAME']
table = dynamodb.Table(table_name)

@app.route('/create', methods=['POST'])
def create_item():
    item = request.json
    table.put_item(Item=item)
    return jsonify({"message": f"Item {item['id']} created."}), 201

@app.route('/read/<string:item_id>', methods=['GET'])
def read_item(item_id):
    response = table.get_item(Key={'id': item_id})
    item = response.get('Item', None)
    if item:
        return jsonify(item), 200
    else:
        return jsonify({"message": f"Item {item_id} not found."}), 404

@app.route('/update/<string:item_id>', methods=['PUT'])
def update_item(item_id):
    update_data = request.json
    update_expression = "SET " + ", ".join([f"#{k} = :{k}" for k in update_data])
    expression_attribute_names = {f"#{k}": k for k in update_data}
    expression_attribute_values = {f":{k}": v for k, v in update_data.items()}

    table.update_item(
        Key={'id': item_id},
        UpdateExpression=update_expression,
        ExpressionAttributeNames=expression_attribute_names,
        ExpressionAttributeValues=expression_attribute_values
    )
    return jsonify({"message": f"Item {item_id} updated."}), 200

@app.route('/delete/<string:item_id>', methods=['DELETE'])
def delete_item(item_id):
    table.delete_item(Key={'id': item_id})
    return jsonify({"message": f"Item {item_id} deleted."}), 200

@app.route('/', methods=['GET'])
def health_check():
    return jsonify({"message": "Server is running"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)