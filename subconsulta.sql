create database subconsulta
go

use subconsulta
go

create table clientes(
	id_cliente int primary key,
	nome varchar(100),
	cidade varchar(100)
)

CREATE TABLE pedidos (
id_pedido INT PRIMARY KEY,
id_cliente INT,
valor DECIMAL(10, 2),
data_pedido DATE,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
go
INSERT INTO clientes (id_cliente, nome, cidade) VALUES
(1, 'João', 'São Paulo'),
(2, 'Maria', 'Rio de Janeiro'),
(3, 'Pedro', 'Salvador');
go
INSERT INTO pedidos (id_pedido, id_cliente, valor, data_pedido) VALUES
(1, 1, 100.00, '2025-05-01'),
(2, 2, 150.00, '2025-05-02'),
(3, 3, 200.00, '2025-05-03'),
(4, 1, 50.00, '2025-05-04');
go



SELECT nome FROM clientes WHERE id_cliente IN ( SELECT id_cliente FROM pedidos WHERE valor > 100);
GO
-- 2. Clientes com pedidos acima da média
SELECT nome FROM clientes WHERE id_cliente IN (SELECT id_cliente FROM pedidos WHERE valor > (SELECT AVG(valor) FROM pedidos));
GO
-- 3. Clientes que ainda não fizeram nenhum pedido
SELECT nome FROM clientes WHERE id_cliente NOT IN (SELECT id_cliente FROM pedidos);
GO
-- 4. Nome dos clientes e valor do maior pedido (subconsulta no SELECT)
SELECT nome, (SELECT MAX(valor) FROM pedidos WHERE pedidos.id_cliente = clientes.id_cliente) AS maior_pedido FROM clientes;
GO
-- 5. Nome dos clientes e soma dos valores de seus pedidos
SELECT nome, (SELECT SUM(valor) FROM pedidos WHERE pedidos.id_cliente = clientes.id_cliente) AS total_pedidos FROM clientes;
GO
-- 6. Cidades com pelo menos um cliente que fez pedido (com EXISTS)
SELECT DISTINCT cidade FROM clientes c WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente);
GO
-- 7. Clientes com mais de um pedido (com COUNT)
SELECT nome FROM clientes WHERE ( SELECT COUNT(*) FROM pedidos WHERE pedidos.id_cliente = clientes.id_cliente) > 1;

-- 8. Clientes com pedidos exatamente iguais à média dos pedidos
SELECT nome FROM clientes WHERE id_cliente IN ( SELECT id_cliente FROM pedidos WHERE valor = (SELECT AVG(valor) FROM pedidos));
GO
-- 9. Cidades onde o maior valor de pedido de um cliente da cidade é > R$150
SELECT cidade FROM clientes WHERE (SELECT MAX(valor) FROM pedidos WHERE pedidos.id_cliente = clientes.id_cliente) > 110;

-- 10. Nome de cada cliente com valor do pedido mais recente (usando TOP 1)
SELECT nome, (SELECT TOP 1 valor FROM pedidos p WHERE p.id_cliente = c.id_cliente ORDER BY data_pedido DESC) AS pedido_mais_recente FROM clientes c;
GO
