using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using System.Data.Sql;
using System.Data.SqlClient;

namespace nsConexionSQL
{
	
	//ejemplo de como usar
	/*	
	public partial class MainForm : Form
	{
		private ConexionSQL db;
		
		public MainForm()
		{
			InitializeComponent();
		}
		
		void MainFormLoad(object sender, EventArgs e)
		{
			db = new ConexionSQL("MiBase"); // base de datos
		}
		
		void Button1Click(object sender, EventArgs e)
		{
			// 1) Llenar un DataGridView
			db.LlenarGrid(dataGridView1, "SELECT TOP 10 * FROM Clientes");

			// 2) Obtener un solo registro
			var row = db.ObtenerData("SELECT TOP 1 * FROM Clientes");
			if (row != null)
				MessageBox.Show("Cliente encontrado: "+ row["clie_nombre"]);

			// 3) Ejecutar un comando (INSERT, UPDATE o DELETE)
			int filas = db.EjecutarComandoSQL("UPDATE Clientes SET Nombre='Juan' WHERE clie_id=1");
			MessageBox.Show("Filas afectadas: "+filas);

			// 4) Ejecutar escalar (ejemplo COUNT)
			var total = db.EjecutarEscalar("SELECT COUNT(*) FROM Clientes");
			MessageBox.Show("Cantidad de clientes: "+ total);
		}
		

	}*/
	
	
	
	
	public class ConexionSQL
	{
		private readonly string _connectionString;
		
		public ConexionSQL(string baseDatos, string servidor = "localhost")
		{
			_connectionString = "Server="+servidor+";Database="+baseDatos+";Trusted_Connection=True;";
		}
		
		public void LlenarGrid(DataGridView grid, string consulta)
		{
			try
			{
				using (var conexion = new SqlConnection(_connectionString))
					using (var adaptador = new SqlDataAdapter(consulta, conexion))
				{
					var dt = new DataTable();
					adaptador.Fill(dt);
					grid.DataSource = dt;
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show("Error al llenar el grid:\n"+ex.Message);
			}
		}
		
		public DataRow ObtenerData(string consulta)
		{
			try
			{
				using (var conexion = new SqlConnection(_connectionString))
					using (var adaptador = new SqlDataAdapter(consulta, conexion))
				{
					var dt = new DataTable();
					adaptador.Fill(dt);
					return dt.Rows.Count > 0 ? dt.Rows[0] : null;
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show("Error al obtener datos:\n"+ex.Message);
				return null;
			}
		}
		
		public int EjecutarComandoSQL(string sql)
		{
			try
			{
				using (var conexion = new SqlConnection(_connectionString))
					using (var cmd = new SqlCommand(sql, conexion))
				{
					conexion.Open();
					return cmd.ExecuteNonQuery();
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show("Error al ejecutar comando SQL:\n"+ex.Message);
				return 0;
			}
		}
		
		public object EjecutarEscalar(string sql)
		{
			try
			{
				using (var conexion = new SqlConnection(_connectionString))
					using (var cmd = new SqlCommand(sql, conexion))
				{
					conexion.Open();
					return cmd.ExecuteScalar();
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show("Error al ejecutar escalar:\n"+ex.Message);
				return null;
			}
		}
	}
}
	