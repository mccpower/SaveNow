//
//  untitled.m
//  EFM
//
//  Created by Noemi on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PreferenciasController.h"
#import <QuartzCore/QuartzCore.h>

@interface PreferenciasController (PrivateMethods)
-(void)actualizar:(NSNumber *)sobre_Actualizar Presupuesto:(NSNumber *)presupuesto_Actualizar;
-(void)recalcular:(NSNumber *)sobre_Actualizar Presupuesto:(NSNumber *)presupuesto_Actualizar;
-(void)sumarPresupuestos;

@end

@implementation PreferenciasController
@synthesize btnFeedback;
@synthesize lblAlertaDiaria;
@synthesize lblSobre0,lblSobre1,lblSobre2,lblSobre3,lblSobre4,txtSobre0,txtSobre1,txtSobre2,txtSobre3,txtSobre4,tituloPresupuestosSobres,tituloMoneda,tituloTotal,totalDato,segmEleccionMoneda,sobreActualizar,presupuestoActualizar;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    NSError *error;
    
    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                         name:@"iPhone1"
                                                        value:@"iv1"
                                                    withError:&error]) {
        // Handle error here
    }
    
    if (![[GANTracker sharedTracker] trackEvent:@"Carga preferencias"
                                         action:@"viewDidLoad"
                                          label:@"PreferenciasController"
                                          value:-1
                                      withError:&error]) {
        // Handle error here
    }
    
    if (![[GANTracker sharedTracker] trackPageview:@"Preferencias"
                                         withError:&error]) {
        // Handle error here
    }

    
    [[btnFeedback layer] setCornerRadius:8.0f];
    [[btnFeedback layer] setMasksToBounds:YES];
    [[btnFeedback layer] setBorderWidth:1.0f];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//append filename to docs directory
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	NSArray *listaTiposSobres = [[NSArray alloc] initWithObjects:NSLocalizedString(@"necesidadesBasicas",@""),NSLocalizedString(@"gastosFijos",@"")
								  ,NSLocalizedString(@"transporte",@""),NSLocalizedString(@"ocio",@""),NSLocalizedString(@"otrosGastos",@"")
								  ,NSLocalizedString(@"ahorro",@""),nil];
	NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	
	NSMutableDictionary *infoSobre = [[NSMutableDictionary alloc]init];
	
	lblSobre0.text  = [listaTiposSobres objectAtIndex:0];
	lblSobre1.text  = [listaTiposSobres objectAtIndex:1];
	lblSobre2.text  = [listaTiposSobres objectAtIndex:2];
	lblSobre3.text  = [listaTiposSobres objectAtIndex:3];
	lblSobre4.text  = [listaTiposSobres objectAtIndex:4];
	
	tituloPresupuestosSobres.text=NSLocalizedString(@"tituloPresupuestosSobres", @"");
	tituloMoneda.text=NSLocalizedString(@"tituloMoneda", @"");
	tituloTotal.text=NSLocalizedString(@"tituloTotal",@"");
	
	//Cargo los presupuestos actuales
	float total = 0.0;
	for (int i=0; i<5; i++) {
		infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:i];
		switch (i) {
			case 0:
				txtSobre0.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			case 1:
				txtSobre1.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			case 2:
				txtSobre2.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			case 3:
				txtSobre3.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];				
				break;
			case 4:
				txtSobre4.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			default:
				break;
		}
		total = total + [[infoSobre valueForKey:@"presupuesto"] floatValue];
	}
	totalDato.text= [NSString stringWithFormat:@"%.2f",total];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	NSString *moneda;
	moneda = [userDefaults objectForKey:@"Moneda"];
	if ((moneda == nil) ||  (moneda == @"€"))
	{
		segmEleccionMoneda.selectedSegmentIndex = 0;
	}
	else if (moneda == @"$")
		  {
			  segmEleccionMoneda.selectedSegmentIndex = 2;
		  }else 
		   {
			  segmEleccionMoneda.selectedSegmentIndex = 1;
		   }

    
	
	txtSobre0.keyboardType=UIKeyboardTypeDecimalPad;
	txtSobre1.keyboardType=UIKeyboardTypeDecimalPad;
	txtSobre2.keyboardType=UIKeyboardTypeDecimalPad;
	txtSobre3.keyboardType=UIKeyboardTypeDecimalPad;
	txtSobre4.keyboardType=UIKeyboardTypeDecimalPad;

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
    [self setBtnFeedback:nil];
    [self setLblAlertaDiaria:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lblSobre0 release];
	[lblSobre1 release];
	[lblSobre2 release];
	[lblSobre3 release];
	[lblSobre4 release];
	[txtSobre0 release];
	[txtSobre1 release];
	[txtSobre2 release];
	[txtSobre3 release];
	[txtSobre4 release];
	[tituloPresupuestosSobres release];
	[tituloMoneda release];
	[tituloTotal release];
	[totalDato release];
	[segmEleccionMoneda release];
	[sobreActualizar release];
	[presupuestoActualizar release];
    [btnFeedback release];
    [lblAlertaDiaria release];
    [super dealloc];
}

-(IBAction) botonActualizarPresupuesto:(id)sender
{
	
	//Obtenemos el título del botón pulsado, nos indicará la página del sobre
	NSString *sobre = [[NSString alloc] init];
	sobre = [sender titleForState:UIControlStateNormal];
	
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
	//Ya tenemos el índice del sobre que vamos a actualizar
	self.sobreActualizar = [f numberFromString:sobre];
	NSString *presupuesto = [[NSString alloc]init];
	
    
    NSError *error;
    
   
    
	//Presupuesto a actualizar
	switch ([sobreActualizar intValue]) {
		case 0:
            if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                                 action:@"actualizar gastos básicos (comida...)"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&error]) {
                // Handle error here
            }

			presupuesto = txtSobre0.text;
			[txtSobre0 resignFirstResponder]; 
			break;
		case 1:
            
            
            if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                                 action:@"actualizar Costes fijos"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&error]) {
                // Handle error here
            }
            
			presupuesto = txtSobre1.text;
			[txtSobre1 resignFirstResponder]; 
			break;
		case 2:
            
            
            if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                                 action:@"actualizar Transporte"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&error]) {
                // Handle error here
            }

			presupuesto = txtSobre2.text;
			[txtSobre2 resignFirstResponder]; 
			break;
		case 3:        
            
            if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                                 action:@"actualizar Ocio"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&error]) {
                // Handle error here
            }

			presupuesto = txtSobre3.text;
			[txtSobre3 resignFirstResponder]; 
			break;
		case 4:            
            
            if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                                 action:@"actualizar Otros Gastos"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&error]) {
                // Handle error here
            }

			presupuesto = txtSobre4.text;
			[txtSobre4 resignFirstResponder]; 
			break;
		default:
			break;
	}
	
	if([presupuesto length] == 0){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tituloError", @"") message:NSLocalizedString(@"mensajeError", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"botonAceptar", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}else{
		
		self.presupuestoActualizar = [f numberFromString:presupuesto];
		UIActionSheet *myActionSheet=[[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"tituloActualizacionPresupuesto", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"botonCancelar", @"") destructiveButtonTitle:NSLocalizedString(@"botonAhora", @"") otherButtonTitles:NSLocalizedString(@"botonProximoReset", @""),nil]autorelease];		
		EFMAppDelegate *midelegado= (EFMAppDelegate *)[[UIApplication sharedApplication] delegate];
		[myActionSheet showFromTabBar:(UITabBar *)[[midelegado tabBarController] view]];
		
		
	} 
	
	
	[f release];
	
	
}


-(IBAction) vaciarTextbox:(id)sender{
	UITextView *cajaTexto = (UITextView*)sender;
	[cajaTexto setText:nil];
	
}


-(void)recalcular:(NSNumber *)sobre_Actualizar Presupuesto:(NSNumber *)presupuesto_Actualizar{
	
	//Se recalcula todo con el presupuesto que se acaba de guardar
	NSMutableArray *listaInfoSobres = [[NSMutableArray alloc]init];
	NSMutableDictionary *infoSobre = [[NSMutableDictionary alloc]init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//append filename to docs directory
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	//NSString *pathData = [[NSBundle mainBundle] pathForResource:@"SobresDetalleData" ofType:@"plist"];
	listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:[sobre_Actualizar intValue]];
	
	//Se actualiza el presupuesto
	[infoSobre setValue:presupuesto_Actualizar forKey:@"presupuesto"];
	[infoSobre setValue:presupuesto_Actualizar forKey:@"presupuestoPendiente"];
	//Se actualiza el porcentaje gastado
	
	if ([[infoSobre valueForKey:@"gastado"] intValue] != 0){
		int nuevo_porcentaje = (([[infoSobre valueForKey:@"gastado"] intValue] * 100) / [presupuesto_Actualizar intValue]);
		NSNumber *n_porcentaje = [[NSNumber alloc] initWithInt:nuevo_porcentaje];
		[infoSobre setValue:n_porcentaje forKey:@"porcentaje"];
	}
	//Actualizamos el array
	[listaInfoSobres replaceObjectAtIndex:[sobre_Actualizar intValue] withObject:infoSobre];
	//Actualizamos el .plist
    [listaInfoSobres writeToFile:pathData atomically:YES]; 
	
}

-(void)actualizar:(NSNumber *)sobre_Actualizar Presupuesto:(NSNumber *)presupuesto_Actualizar{
	//Opción en el próximo reset
	
	//Se actualiza el presupuesto pendiente
	NSMutableArray *listaInfoSobres = [[NSMutableArray alloc]init];
	NSMutableDictionary *infoSobre = [[NSMutableDictionary alloc]init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//append filename to docs directory
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:[sobre_Actualizar intValue]];
	//Se actualiza el presupuesto
	[infoSobre setValue:presupuesto_Actualizar forKey:@"presupuestoPendiente"];
	
	//Actualizamos el array
	[listaInfoSobres replaceObjectAtIndex:[sobre_Actualizar intValue] withObject:infoSobre];
	//Actualizamos el .plist
    [listaInfoSobres writeToFile:pathData atomically:YES]; 
	
}	


//Manejar el actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	 NSError *error;
	if (buttonIndex==[actionSheet destructiveButtonIndex]){
		if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                             action:@"Actualiza ahora"
                                              label:@"PreferenciasController"
                                              value:-1
                                          withError:&error]) {
            // Handle error here
        }
        NSLog(@"Actualiza AHORA");
		
		[self recalcular:self.sobreActualizar Presupuesto:self.presupuestoActualizar];
		self.sumarPresupuestos;
	}
	
    if (buttonIndex ==1 ){
        // Actualiza en el próximo reset
        if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                             action:@"Actualizará en el próximo reset"
                                              label:@"PreferenciasController"
                                              value:-1
                                          withError:&error]) {
            // Handle error here
        }
        
		NSLog(@"Solo actualiza el presupuesto en el plis y de ahi lo cogerá al hacer el reset");
		[self actualizar:self.sobreActualizar Presupuesto:self.presupuestoActualizar];
		self.sumarPresupuestos;
    }
    
    if (buttonIndex ==2) //btn cancelar
    {
               
        if (![[GANTracker sharedTracker] trackEvent:@"Actualizar gastos"
                                             action:@"Usuario cancela acción"
                                              label:@"PreferenciasController"
                                              value:-1
                                          withError:&error]) {
            // Handle error here
        }

    }
}

-(IBAction)ocultarTeclado:(id)sender{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	NSMutableDictionary *infoSobre = [[NSMutableDictionary alloc]init];
	
	//Cargo los presupuestos actuales
	float total=0.0;
	
	for (int i=0; i<5; i++) {
		infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:i];
		switch (i) {
			case 0:
				txtSobre0.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			case 1:
				txtSobre1.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			case 2:
				txtSobre2.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			case 3:
				txtSobre3.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];				
				break;
			case 4:
				txtSobre4.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
				break;
			default:
				break;
		}
		total = total + [[infoSobre valueForKey:@"presupuesto"] floatValue];

	}
	
	
	totalDato.text= [NSString stringWithFormat:@"%.2f",total];
	[txtSobre0 resignFirstResponder];
	[txtSobre1 resignFirstResponder];
	[txtSobre2 resignFirstResponder];
	[txtSobre3 resignFirstResponder];
	[txtSobre4 resignFirstResponder];
}


/* Método para controlar cuando el usuario cambia la moneda usando el segmented */
-(IBAction)cambiarMoneda:(id)sender{
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSString *moneda = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	[userDefaults setValue:moneda forKey:@"Moneda"];
	[userDefaults synchronize];
}

- (IBAction)sendFeedback:(id)sender 
{
    
    MFMailComposeViewController *mailController;
    if ([MFMailComposeViewController canSendMail]) {
        mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:@"Save Now Feedback"];
        [mailController setToRecipients:[NSArray arrayWithObject:@"pynsoftware@gmail.com"]];
        
        NSString *device=[NSString stringWithFormat:@"Device:%@ System Version:%@",[[UIDevice currentDevice]model],[[UIDevice currentDevice]systemVersion]];
        NSString *version = [NSString stringWithFormat:@"App version : %@", APP_VERSION];
        [mailController setMessageBody: [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n%@\n\n%@", device, version]
                                isHTML: NO ];
        [self presentModalViewController:mailController animated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to email feedback. Does your iOS device support email?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }

}

- (IBAction)cambioAlertaDiaria:(id)sender {
}
-(void)sumarPresupuestos{
	//Cargo los presupuestos actuales
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathData =  [documentsDirectory stringByAppendingPathComponent:@"SobresDetalleData.plist"];
	
	NSMutableArray *listaInfoSobres = [NSMutableArray arrayWithContentsOfFile:pathData];
	NSMutableDictionary *infoSobre = [[NSMutableDictionary alloc]init];
	float total=0.0;
	BOOL sw=FALSE;
	for (int i=0; i<5; i++) {
		infoSobre = (NSMutableDictionary*)[listaInfoSobres objectAtIndex:i];
		switch (i) {
			case 0:
				if ([[infoSobre valueForKey:@"presupuesto"] floatValue] != [[infoSobre valueForKey:@"presupuestoPendiente"] floatValue])
				{
					txtSobre0.text = [[infoSobre valueForKey:@"presupuestoPendiente"] stringValue];
					sw=TRUE;
				}
				else 
				{
					txtSobre0.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
					sw=FALSE;
				}
				break;
			case 1:
				if ([[infoSobre valueForKey:@"presupuesto"] floatValue] != [[infoSobre valueForKey:@"presupuestoPendiente"] floatValue])
				{
					txtSobre1.text = [[infoSobre valueForKey:@"presupuestoPendiente"] stringValue];
					sw=TRUE;
				}
				else 
				{
					txtSobre1.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
					sw=FALSE;
				}
				break;
			case 2:
				if ([[infoSobre valueForKey:@"presupuesto"] floatValue] != [[infoSobre valueForKey:@"presupuestoPendiente"] floatValue])
				{
					txtSobre2.text = [[infoSobre valueForKey:@"presupuestoPendiente"] stringValue];
					sw=TRUE;
				}
				else 
				{
					txtSobre2.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
					sw=FALSE;
				}
				break;				
			case 3:
				if ([[infoSobre valueForKey:@"presupuesto"] floatValue] != [[infoSobre valueForKey:@"presupuestoPendiente"] floatValue])
				{
					txtSobre3.text = [[infoSobre valueForKey:@"presupuestoPendiente"] stringValue];
					sw=TRUE;
				}
				else 
				{
					txtSobre3.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
					sw=FALSE;
				}
				break;				
			case 4:
				if ([[infoSobre valueForKey:@"presupuesto"] floatValue] != [[infoSobre valueForKey:@"presupuestoPendiente"] floatValue])
				{
					txtSobre4.text = [[infoSobre valueForKey:@"presupuestoPendiente"] stringValue];
					sw=TRUE;
				}
				else 
				{
					txtSobre4.text = [[infoSobre valueForKey:@"presupuesto"] stringValue];
					sw=FALSE;
				}
				break;
				
			default:
				break;
		}
		if (sw) {
			total = total + [[infoSobre valueForKey:@"presupuestoPendiente"] floatValue];
	
		}else {
			total = total + [[infoSobre valueForKey:@"presupuesto"] floatValue];

		}
	}
	totalDato.text= [NSString stringWithFormat:@"%.2f",total];

}

#pragma mark_Delegate email

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	UIAlertView *alert = nil;
    
    NSError *errorAnalytics;
	switch (result) {
		case MFMailComposeResultSent:
            if (![[GANTracker sharedTracker] trackEvent:@"Feedback"
                                                 action:@"Usuario envía feedback"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&errorAnalytics]) {
                // Handle error here
            }

			alert = [[UIAlertView alloc] initWithTitle:@"Sent" message:@"Feedback has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case MFMailComposeResultSaved:
            if (![[GANTracker sharedTracker] trackEvent:@"Feedback"
                                                 action:@"Usuario guarda email feedback"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&errorAnalytics]) {
                // Handle error here
            }
			alert = [[UIAlertView alloc] initWithTitle:@"Saved draft" message:@"Draft feedback has been saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case MFMailComposeResultFailed:
            if (![[GANTracker sharedTracker] trackEvent:@"Feedback"
                                                 action:@"Error al enviar feedback"
                                                  label:@"PreferenciasController"
                                                  value:-1
                                              withError:&errorAnalytics]) {
                // Handle error here
            }
			alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, feedback could not be sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		default:
			break;
	}
	if (alert != nil) {
		[alert	show];
		[alert release];
	}
    
	[self dismissModalViewControllerAnimated:YES];
}


@end
