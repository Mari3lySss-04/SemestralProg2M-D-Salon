<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Facturas del Cliente</title>
    <link rel="stylesheet" href="ConsultaFacturasPorCliente.css">
    <style>
        .message {
            padding: 20px;
            color: #fff;
            text-align: center;
            border-radius: 4px;
        }
        .success {
            background-color: #4CAF50;
        }
        .error {
            background-color: #f44336;
        }
        .back-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>Facturas del Cliente</h1>
    <div class="factura-result">
        <%
            // Obtener el parámetro de la cédula del cliente
            String cedulaCliente = request.getParameter("cedula_cliente");

            if (cedulaCliente != null && !cedulaCliente.trim().isEmpty()) {
                // Variables de conexión
                Connection conn = null;
                PreparedStatement ps = null;

                try {
                    // Cargar el driver JDBC
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    // Establecer la conexión con la base de datos
                    String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; // Cambiar según la configuración de la base de datos
                    String username = "abiel"; // Cambiar por el usuario de la base de datos
                    String password = "2004"; // Cambiar por la contraseña de la base de datos
                    conn = DriverManager.getConnection(dbURL, username, password);

                    // Consultar las facturas del cliente
                    String sql = "SELECT f.N_factura, f.Fecha, c.P_Nombre || ' ' || c.P_Apellido AS Cliente, col.P_Nombre || ' ' || col.P_Apellido AS Colaboradora FROM Factura f JOIN Cliente c ON f.Id_Cliente = c.Id_Cliente JOIN Colaborador col ON f.Id_Colaborador = col.Id_Colaborador WHERE c.Cedula = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, cedulaCliente);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
        %>
        <h2>Facturas del Cliente: <%= rs.getString("Cliente") %></h2>
        <table>
            <tr>
                <th>Número de Factura</th>
                <th>Fecha</th>
                <th>Colaboradora</th>
            </tr>
            <%
                do {
            %>
            <tr>
                <td><%= rs.getString("N_factura") %></td>
                <td><%= rs.getDate("Fecha") %></td>
                <td><%= rs.getString("Colaboradora") %></td>
            </tr>
            <%
                } while (rs.next());
            %>
        </table>
        <%
        } else {
        %>
        <div class="message error">No se encontraron facturas para este cliente.</div>
        <%
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
            } finally {
                // Cerrar recursos
                if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        } else {
        %>
        <div class="message error">Cédula de cliente no proporcionada.</div>
        <%
            }
        %>
    </div>
    <a href="ConsultaFacturasPorCliente.html" class="back-button">Volver al formulario de consulta</a>
</div>
</body>
</html>
