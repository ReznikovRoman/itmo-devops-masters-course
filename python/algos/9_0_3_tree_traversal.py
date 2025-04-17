class Node:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None


# Пример: строим дерево вручную
root = Node(1)
root.left = Node(2)
root.right = Node(3)
root.left.left = Node(4)
root.left.right = Node(5)

#    1
# 2    3
#4 5

def in_order(node):
    if node:
        in_order(node.left)
        print(node.val, end=" ")
        in_order(node.right)


def pre_order(node):
    if node:
        print(node.val, end=" ")
        pre_order(node.left)
        pre_order(node.right)


def post_order(node):
    if node:
        post_order(node.left)
        post_order(node.right)
        print(node.val, end=" ")


print("In-order обход дерева:")
in_order(root)     # 4 2 5 1 3

print("\nPre-order обход дерева:")
pre_order(root)    # 1 2 4 5 3

print("\nPost-order обход дерева:")
post_order(root)   # 4 5 2 3 1
