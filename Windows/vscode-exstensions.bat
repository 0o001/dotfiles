extensionlist=(
ms-python.python
ms-python.vscode-pylance
ms-vscode.powershell
bierner.lit-html
)

for i in ${extensionlist[@]}; do
  code --install-extension $i
done