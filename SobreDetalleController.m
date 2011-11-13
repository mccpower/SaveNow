//
//  SobreDetalleController.m
//  EFM
//
//  Created by Noemi on 11/21/10.
//  Copyright 2010 Pynsoft All rights reserved.
//

#import "SobreDetalleController.h"

@interface SobreDetalleController (PrivateMethods)
-(void)actualizarGastado:(NSNumber*)dineroSacar;
-(void)ocultarInformacion;
@end

@implementation SobreDetalleController
@synthesize lblTitulo,lblPresupuesto,lblGastado,lblPorcentaje,presupuestoDato,gastadoDato,porcentajeDato,ultimoGastoDato,txtDinero,botonSacar,botonReset,lblUltimoGasto,pageNumber;
@synthesize lblFechaReset,lblMonedaPresupuesto,lblMonedaGastado,lblMonedaUltimoGasto;
@synthesize fondoInformacion,textoInformacion,dineroAnadirAhorro;
@synthesize fechaResetDato;


-(IBAction)sacarDineroSobre:(id)sender
{
    NSError *error;
	NSString *stringAnalytics=[NSString stringWithFormat:@"Usuario saca dinero sobre %@",lblTitulo.text];
    if (![[GANTracker sharedTracker] trackEvent:@"Sacar dinero"
                                         action:stringAnalytics
                                          label:@"SobreDetalleController"
                                          value:-1
                                      withError:&error]) {
        // Handle error here
    }
    
	NSLog(@"Método sacar dinero sobre");
	
	//Se oculta la vista de información por si el usuario ha pulsado en sacar dinero y estaba visible
	self.ocultarInformacion;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	NSMutableArray *lista_InfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	
	NSMutableDictionary *info_Sobre = (NSMutableDictionary*)[lista_InfoSobres objectAtIndex:pageNumber];
	
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSString *cadena = txtDinero.text;
	
	if ((![cadena isEqual:@""]) && (cadena != nil))
	{
		NSNumber * myNumber = [f numberFromString:cadena];
		[f release];
		NSLog(@"mi dinero %f",myNumber);
	
		NSNumber *presupuesto = [info_Sobre valueForKey:@"presupuesto"];
	
		NSNumber *gastado = [info_Sobre valueForKey:@"gastado"];
		NSString *mensaje = [[[NSString alloc]init]autorelease];
		NSString *botonOK = [[[NSString alloc]init]autorelease];
		
		
		if  (([presupuesto floatValue] - ([myNumber floatValue] +  [gastado floatValue])) < 0)
		{		
			if (pageNumber == 5)
			{
				mensaje=NSLocalizedString(@"mensajeNoTienesAhorros",@"");
				//*alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message: delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
				botonOK=nil;
				txtDinero.text=@"";
			}
			else
			{
				NSLog(@"¿Estas seguro? vas a numeros rojos!");
				mensaje=NSLocalizedString(@"mensajeNumerosRojos",@"");
				botonOK=NSLocalizedString(@"botonAceptarNumerosRojos",@"");

			}				
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:mensaje delegate:self cancelButtonTitle:NSLocalizedString(@"botonCancelarNumerosRojos",@"") otherButtonTitles:botonOK, nil];
			[alert show];
			[alert release];		
		}
		else	
		{
			[self actualizarGastado:myNumber];	
			ultimoGastoDato.text=[myNumber stringValue];
		}				
	}
	[txtDinero resignFirstResponder]; 	
}

-(IBAction)resetDineroSobre:(id)sender
{
    NSError *error;
	NSString *stringAnalytics=[NSString stringWithFormat:@"Usuario resetea sobre %@",lblTitulo.text];
    if (![[GANTracker sharedTracker] trackEvent:@"Reset sobre"
                                         action:stringAnalytics
                                          label:@"SobreDetalleController"
                                          value:-1
                                      withError:&error]) {
        // Handle error here
    }
	//Se oculta la vista de información por si el usuario ha pulsado en reset y estaba visible
	self.ocultarInformacion;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	NSMutableDictionary *infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:pageNumber];
	
	NSNumber *presupuesto = [[NSNumber alloc]init];
	presupuesto=[infoSobre valueForKey:@"presupuesto"];
	
	NSNumber *gastado = [[NSNumber alloc]init];
	gastado=[infoSobre valueForKey:@"gastado"];

	
	if (pageNumber == 5) {
		UIAlertView *avisoResetAhorro = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"mensajeResetAhorros",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"botonCancelarResetAhorros",@"") otherButtonTitles:NSLocalizedString(@"botonAceptarResetAhorros",@""), nil];
		[avisoResetAhorro show];
		[avisoResetAhorro release];
	}
	else {
		
		//NSMutableString *textoAhorro = [[NSMutableString alloc] initWithString:@"Enviar a "];
		NSString *textoAhorro = [[[NSString alloc]init]autorelease];	
		if (([presupuesto floatValue] - [gastado floatValue]) <= 0)
		{
			textoAhorro=nil;	
		}
		else
		{
			dineroAnadirAhorro = [presupuesto floatValue] - [gastado floatValue];
			textoAhorro = NSLocalizedString(@"botonEnviarAhorro",@"");
			//[textoAhorro appendString:[lista_TipoSobres objectAtIndex:5]];
		}
		UIActionSheet *myActionSheet=[[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"tituloResetSobre",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"botonCancelarResetSobre",@"") destructiveButtonTitle:NSLocalizedString(@"botonSoloReseteo",@"") otherButtonTitles:textoAhorro,nil]autorelease];
		EFMAppDelegate *midelegado= (EFMAppDelegate *)[[UIApplication sharedApplication] delegate];		
		[myActionSheet showFromTabBar:(UITabBar *)[[midelegado tabBarController] view]];
	} // Sobre distinto al de ahorro
	
}

// load the view nib and initialize the pageNumber ivar
- (id)initWithPageNumber:(int)page
{
    if (self = [super initWithNibName:@"SobreDetalle" bundle:nil])
    {
        pageNumber = page;
    }
    return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	lblPresupuesto.text=NSLocalizedString(@"textoPresupuesto",@"");
	lblGastado.text=NSLocalizedString(@"textoGastado",@"");
	lblPorcentaje.text=NSLocalizedString(@"textoPorcentaje",@"");
	lblUltimoGasto.text=NSLocalizedString(@"textoUltimoGasto",@"");
	lblFechaReset.text=NSLocalizedString(@"textoUltimoReset",@"");
	
	[botonSacar setTitle:NSLocalizedString(@"textoBotonSacar",@"")forState:0];
	[botonReset setTitle:NSLocalizedString(@"textoBotonReset",@"")forState:0];
	
	txtDinero.keyboardType=UIKeyboardTypeDecimalPad;
	
	self.ocultarInformacion;
	textoInformacion.font = [UIFont fontWithName:@"Helvetica" size:11];
	
	[self cargarDetalleVista];
	[super viewDidLoad];

}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lblTitulo release];
	[lblPresupuesto release];
	[lblGastado release];
	[lblPorcentaje release];
	[presupuestoDato release];
	[gastadoDato release];
	[porcentajeDato release];
	[ultimoGastoDato release];
	[txtDinero release];
	[botonSacar release];
	[botonReset release];
	[lblUltimoGasto release];
	[lblFechaReset release];
	[lblMonedaPresupuesto release];
	[lblMonedaGastado release];
	[lblMonedaUltimoGasto release];
	[fondoInformacion release];
	[textoInformacion release];
	[fechaResetDato release];
	
    [super dealloc];
}

//Métodos de gestión del ActionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	NSLog(@"ButtonsIndex: %i",buttonIndex);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//append filename to docs directory
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	NSMutableDictionary *infoSobre = [[NSMutableDictionary alloc]init];
	
    NSError *error;	
	if (buttonIndex==[actionSheet destructiveButtonIndex])
	{
		NSLog(@"Solo resetear");
        
        NSString *stringAnalytics=[NSString stringWithFormat:@"Solo resetear sobre %@",lblTitulo.text];
        if (![[GANTracker sharedTracker] trackEvent:@"Resetear dinero"
                                             action:stringAnalytics
                                              label:@"SobreDetalleController"
                                              value:-1
                                          withError:&error]) 
        {
            // Handle error here
        }        
			infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:pageNumber];
			//Para resetear pone a 0 el valor de gastado, se marca la fecha del reseteo
			
			NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
			[date_formater setDateStyle:NSDateFormatterShortStyle];
			
			NSNumber *cero = [[[NSNumber alloc] initWithInt:0] autorelease];
			//Asignando los valores
			[infoSobre setValue:cero forKey:@"gastado"];
			[infoSobre setValue:cero forKey:@"porcentaje"];
			[infoSobre setValue:[date_formater stringFromDate:[NSDate date]] forKey:@"fechaReset"];
			
		    NSLog(@"%@",[date_formater stringFromDate:[NSDate date]]);
			[date_formater release];
			[infoSobre setValue:cero forKey:@"ultimoGasto"];
			
			NSNumber *presupuestoPtde = [infoSobre valueForKey:@"presupuestoPendiente"];
			if (([presupuestoPtde floatValue]!= [[infoSobre valueForKey:@"presupuesto"] floatValue]) && ([presupuestoPtde intValue]!= 0) ){
				[infoSobre setValue:presupuestoPtde forKey:@"presupuesto"];
			}
			
			//Actualizamos el array
			[listaInfoSobres replaceObjectAtIndex:pageNumber withObject:infoSobre];			
		
		//Actualizamos el .plist
		[listaInfoSobres writeToFile:pathData atomically:YES]; 
		
		//Volvemos a cargar los datos del sobre para que recalcule...
		[self cargarDetalleVista];
	}
	if (buttonIndex==1)
	{
        NSString *stringAnalytics=[NSString stringWithFormat:@"Resetear sobre %@ y enviar a ahorros",lblTitulo.text];
        if (![[GANTracker sharedTracker] trackEvent:@"Resetear dinero"
                                             action:stringAnalytics
                                              label:@"SobreDetalleController"
                                              value:-1
                                          withError:&error]) 
        {
            // Handle error here
        } 
        
		 //Primero resetea
			
		infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:pageNumber];
		//Para resetear pone a 0 el valor de gastado, se marca la fecha del reseteo
			 
		//Dando formato a la fecha
		NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
		[date_formater setDateStyle:NSDateFormatterShortStyle];
		NSNumber *cero = [[[NSNumber alloc] initWithInt:0] autorelease];
		//Asignando los valores
		[infoSobre setValue:cero forKey:@"gastado"];
		[infoSobre setValue:cero forKey:@"porcentaje"];
		[infoSobre setValue:[date_formater stringFromDate:[NSDate date]] forKey:@"fechaReset"];
		[date_formater release];
		[infoSobre setValue:cero forKey:@"ultimoGasto"];
			 
		NSNumber *presupuestoPtde = [infoSobre valueForKey:@"presupuestoPendiente"];
		if (([presupuestoPtde floatValue]!= [[infoSobre valueForKey:@"presupuesto"] floatValue]) && ([presupuestoPtde intValue]!= 0) ){
				 [infoSobre setValue:presupuestoPtde forKey:@"presupuesto"];
		}
			 
		//Actualizamos el array
		[listaInfoSobres replaceObjectAtIndex:pageNumber withObject:infoSobre];
			 
		[listaInfoSobres writeToFile:pathData atomically:YES]; 

		 //Ahora envia a ahorro
		 NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
		 NSLog(@"mandar a sobre ahorro");
		 infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:5];
		 NSNumber *dineroAhorrado = [infoSobre objectForKey:@"presupuesto"];
		float dineroAhorradoTotal = dineroAnadirAhorro + [dineroAhorrado floatValue];
		 NSNumber *ahorroTotal= [[[NSNumber alloc]initWithFloat:dineroAhorradoTotal]autorelease];
		 [infoSobre setValue:ahorroTotal forKey:@"presupuesto"];
		 [infoSobre setValue:ahorroTotal forKey:@"presupuestoPendiente"];
		 [listaInfoSobres writeToFile:pathData atomically:YES]; 

		 [self cargarDetalleVista];
	 }
}


//Métodos de gestión del UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	//Alert desea resetear el sobre de ahorro
	if (pageNumber == 5) {
		if (buttonIndex != 0)
		{
			NSNumber *cero = [[[NSNumber alloc]initWithInt:0]autorelease];
			NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
			[date_formater setDateStyle:NSDateFormatterShortStyle];

			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
			NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
			NSMutableDictionary *infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:pageNumber];
			[infoSobre setValue:cero forKey:@"gastado"];
			[infoSobre setValue:cero forKey:@"porcentaje"];
			[infoSobre setValue:[date_formater stringFromDate:[NSDate date]] forKey:@"fechaReset"];
			[date_formater release];
			[infoSobre setValue:cero forKey:@"ultimoGasto"];
			[infoSobre setValue:cero forKey:@"presupuesto"];
			[infoSobre setValue:cero forKey:@"presupuestoPendiente"];
			
			//Actualizamos el array
			[listaInfoSobres replaceObjectAtIndex:pageNumber withObject:infoSobre];
			//Actualizamos el .plist
			[listaInfoSobres writeToFile:pathData atomically:YES]; 
			[self cargarDetalleVista];		
		}
		
	}
	//alert Vas a quedarte en números rojos!!
	else 
	{
		if (buttonIndex == 0)
		{
			NSLog(@"cancel//No hace nada");
			[txtDinero setText:nil];
		}
		else
		{
			NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
			[f setNumberStyle:NSNumberFormatterDecimalStyle];
			NSString *cadena = txtDinero.text;
			NSNumber * myNumber = [f numberFromString:cadena];
			[f release];
			[self actualizarGastado:myNumber];
			ultimoGastoDato.text=[myNumber stringValue];
		
		}
	}
}


//métodos privados
-(void)actualizarGastado:(NSNumber*)dineroSacar{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	NSMutableArray *lista_InfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	NSMutableDictionary *info_Sobre = (NSMutableDictionary*)[lista_InfoSobres objectAtIndex:pageNumber];
	
	float nuevo_gastado = [dineroSacar floatValue] + [[info_Sobre valueForKey:@"gastado"] floatValue];
	NSNumber *n_gastado = [[NSNumber alloc] initWithFloat:nuevo_gastado];
	[info_Sobre setValue:n_gastado forKey:@"gastado"];
	[info_Sobre setValue:dineroSacar forKey:@"ultimoGasto"];
	
	if ([[[info_Sobre valueForKey:@"gastado"] stringValue] isEqual:@"0"]) {
		gastadoDato.text = [[info_Sobre valueForKey:@"gastado"] stringValue];
		
	}
	else {
		gastadoDato.text = [NSString stringWithFormat:@"%.2f",[[info_Sobre valueForKey:@"gastado"] floatValue]];
	}
	
	int nuevo_porcentaje;
	if ([[info_Sobre valueForKey:@"presupuesto"] intValue]==0) 
	{
		nuevo_porcentaje =100;
	}
	else
	{
		nuevo_porcentaje = trunc(((nuevo_gastado * 100) / [[info_Sobre valueForKey:@"presupuesto"] floatValue]));
		
	}
	NSNumber *n_porcentaje = [[NSNumber alloc] initWithInt:nuevo_porcentaje];
	[info_Sobre setValue:n_porcentaje forKey:@"porcentaje"];
	porcentajeDato.text = [n_porcentaje stringValue];
	
	//Actualizamos el array
	[lista_InfoSobres replaceObjectAtIndex:pageNumber withObject:info_Sobre];
	//Actualizamos el .plist
    [lista_InfoSobres writeToFile:pathData atomically:YES];  
	[txtDinero setText:nil];
	
}
-(void)cargarDetalleVista
{
    NSError *error;
    NSString *stringAnalytics=[NSString stringWithFormat:@"Sobre %@",lblTitulo.text];
    if (![[GANTracker sharedTracker] trackPageview:stringAnalytics
                                         withError:&error]) 
    {
        // Handle error here
    }
    
	NSArray *lista_TiposSobres = [[NSArray alloc] initWithObjects:NSLocalizedString(@"necesidadesBasicas",@""),NSLocalizedString(@"gastosFijos",@"")
								  ,NSLocalizedString(@"transporte",@""),NSLocalizedString(@"ocio",@""),NSLocalizedString(@"otrosGastos",@"")
								  ,NSLocalizedString(@"ahorro",@""),nil];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	NSMutableArray *lista_InfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	NSDictionary *info_Sobre = (NSDictionary*)[lista_InfoSobres objectAtIndex:pageNumber];
	
	if (!pageNumber) {
		pageNumber=0;
	}
	lblTitulo.text  = [lista_TiposSobres objectAtIndex:pageNumber];
	
	
	presupuestoDato.text = [[info_Sobre valueForKey:@"presupuesto"] stringValue];
	if ([[[info_Sobre valueForKey:@"gastado"] stringValue] isEqual:@"0"]) {
		gastadoDato.text = [[info_Sobre valueForKey:@"gastado"] stringValue];

	}
	else {
		gastadoDato.text = [NSString stringWithFormat:@"%.2f",[[info_Sobre valueForKey:@"gastado"] floatValue]];
	}
	
	porcentajeDato.text = [[info_Sobre valueForKey:@"porcentaje"] stringValue];
	
	
	/* cargar titulos */
	lblPresupuesto.text=NSLocalizedString(@"textoPresupuesto", @"");
	lblGastado.text=NSLocalizedString(@"textoGastado", @"");
	lblPorcentaje.text=NSLocalizedString(@"textoPorcentaje", @"");
	
	ultimoGastoDato.text=[[info_Sobre valueForKey:@"ultimoGasto"] stringValue];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	NSString *moneda;
	moneda = [userDefaults objectForKey:@"Moneda"];
	if (moneda == nil) {
		moneda=@"€";
	}
	
	lblMonedaPresupuesto.text=moneda;
	lblMonedaGastado.text=moneda;
	lblMonedaUltimoGasto.text=moneda;
	
	fechaResetDato.text=[info_Sobre valueForKey:@"fechaReset"];
	

}


-(IBAction)ocultarTeclado:(id)sender{
	[txtDinero resignFirstResponder];
	self.ocultarInformacion;
}

-(IBAction)mostrarInformacion:(id)sender
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"Información"
                                         action:@"Boton información pulsado"
                                          label:@"SobreDetalleController"
                                          value:-1
                                      withError:&error]) {
        // Handle error here
    }
    
    
	NSLog(@"Metodo mostrar informacion");
	switch (pageNumber) 
    {
		case 0:
			textoInformacion.text=NSLocalizedString(@"informacionNecesidadesBasicas",@""); 
			break;
		case 1:
			textoInformacion.text=NSLocalizedString(@"informacionGastosFijos",@"");
			break;
		case 2:
			textoInformacion.text=NSLocalizedString(@"informacionTransporte",@""); 
			break;
		case 3:
			textoInformacion.text=NSLocalizedString(@"informacionOcio",@""); 
			break;
		case 4:
			textoInformacion.text=NSLocalizedString(@"informacionOtrosGastos",@""); 
			break;
		case 5:
			textoInformacion.text=NSLocalizedString(@"informacionAhorro",@"");
			break;
		default:
			textoInformacion.text=nil;
			break;
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[fondoInformacion setAlpha:1];
	[textoInformacion setAlpha:1];
	[UIView commitAnimations];

}

-(IBAction)eventoEmpezarEditar:(id)sender{
	NSLog(@"Metodo ocultar informacion cuando está visible y se pulsa sobre el textoBox de sacar dinero");
	self.ocultarInformacion;
}

-(void)ocultarInformacion{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[fondoInformacion setAlpha:0];
	[textoInformacion setAlpha:0];
	[UIView commitAnimations];

}
@end
