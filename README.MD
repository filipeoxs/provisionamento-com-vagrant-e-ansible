
# Comando para criar o Vagrantfile
# O focal64 é o ubuntu 20
vagrant inint ubuntu/focal64 

# Comando para criar a VM
vagrant up

# Para acessar a vm via ssh
vagrant ssh

# Para remover a vm do ambiente
vagrant destroy

# Quando a VM já está criada e algum recurso precisa ser alterado
vagrant reload

# Para alterar algo que mudou na config do ansible
vagrant provision

# Para verificar se as vms estão se comunicando
ansible -i nome_do_arquivo_de_inventario  -u usuario_que_vai_autenticar -k -m ping