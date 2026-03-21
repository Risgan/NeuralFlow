import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TaskFrequency { unica, diaria, semanal, mensual }

enum MonthScheduleType { specificDay, weekPattern }

enum TimePickerStyle { wheel, material }

class CreateTaskResult {
	const CreateTaskResult({
		required this.title,
		required this.time,
		required this.frequency,
		this.unicaDate,
		this.weekDays,
		this.monthScheduleType,
		this.monthSpecificDay,
		this.monthWeek,
		this.monthWeekDay,
	});

	final String title;
	final String? time;
	final TaskFrequency frequency;
	
	// Para Unica
	final DateTime? unicaDate;
	
	// Para Semanal (lista de días: 0=Lun, 1=Mar, 2=Mié, 3=Jue, 4=Vie, 5=Sab, 6=Dom)
	final List<int>? weekDays;
	
	// Para Mensual
	final MonthScheduleType? monthScheduleType;
	final int? monthSpecificDay; // 1-31
	final int? monthWeek; // 0=Primera, 1=Segunda, 2=Tercera, 3=Cuarta, 4=Última
	final int? monthWeekDay; // 0=Lun - 6=Dom
}

class CreateTaskFormSheet extends StatefulWidget {
	const CreateTaskFormSheet({
		required this.onSubmit,
		this.onClose,
		this.initialData,
		this.isEditMode = false,
		super.key,
	});

	final ValueChanged<CreateTaskResult> onSubmit;
	final VoidCallback? onClose;
	final CreateTaskResult? initialData;
	final bool isEditMode;

	@override
	State<CreateTaskFormSheet> createState() => _CreateTaskFormSheetState();
}

class _CreateTaskFormSheetState extends State<CreateTaskFormSheet> {
	final TextEditingController _titleController = TextEditingController();
	TimeOfDay? _selectedTime;
	final TimePickerStyle _timePickerStyle = TimePickerStyle.wheel;
	TaskFrequency _frequency = TaskFrequency.unica;
	
	// Unica
	DateTime? _unicaDate;
	
	// Semanal (días seleccionados: 0=Lun, 1=Mar, 2=Mié, 3=Jue, 4=Vie, 5=Sab, 6=Dom)
	final List<int> _weekDaysSelected = [];
	
	// Mensual
	MonthScheduleType _monthScheduleType = MonthScheduleType.specificDay;
	int _monthSpecificDay = 1;
	int _monthWeek = 0; // 0=Primera, 1=Segunda, 2=Tercera, 3=Cuarta, 4=Última
	int _monthWeekDay = 0; // 0=Lun

	@override
	void initState() {
		super.initState();
		if (widget.initialData != null) {
			final data = widget.initialData!;
			_titleController.text = data.title;
			_frequency = data.frequency;
			_unicaDate = data.unicaDate;
			_monthScheduleType = data.monthScheduleType ?? MonthScheduleType.specificDay;
			_monthSpecificDay = data.monthSpecificDay ?? 1;
			_monthWeek = data.monthWeek ?? 0;
			_monthWeekDay = data.monthWeekDay ?? 0;
			
			if (data.weekDays != null) {
				_weekDaysSelected.addAll(data.weekDays!);
			}
			
			if (data.time != null) {
				final parts = data.time!.split(':');
				if (parts.length == 2) {
					_selectedTime = TimeOfDay(
						hour: int.parse(parts[0]),
						minute: int.parse(parts[1]),
					);
				}
			}
		}
	}

	@override
	void dispose() {
		_titleController.dispose();
		super.dispose();
	}

	Future<void> _pickTime() async {
		if (_timePickerStyle == TimePickerStyle.wheel) {
			await _pickTimeWheel24h();
			return;
		}

		await _pickTimeMaterial24h();
	}

	Future<void> _pickTimeMaterial24h() async {
		final picked = await showTimePicker(
			context: context,
			initialTime: _selectedTime ?? TimeOfDay.now(),
			initialEntryMode: TimePickerEntryMode.inputOnly,
			helpText: 'Selecciona la hora',
			cancelText: 'Cancelar',
			confirmText: 'Seleccionar',
			builder: (context, child) {
				final media = MediaQuery.of(context);
				return MediaQuery(
					data: media.copyWith(
						alwaysUse24HourFormat: false,
						textScaler: const TextScaler.linear(20.0),
					),
					child: child ?? const SizedBox.shrink(),
				);
			},
		);

		if (picked == null) return;
		setState(() {
			_selectedTime = picked;
		});
	}

	Future<void> _pickTimeWheel24h() async {
		final now = DateTime.now();
		final current = _selectedTime ?? TimeOfDay.now();
		DateTime temp = DateTime(
			now.year,
			now.month,
			now.day,
			current.hour,
			current.minute,
		);

		final picked = await showModalBottomSheet<TimeOfDay>(
			context: context,
			isScrollControlled: true,
			useSafeArea: true,
			builder: (sheetContext) {
				final colorScheme = Theme.of(sheetContext).colorScheme;
				return Container(
					height: 320,
					padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
					decoration: BoxDecoration(
						color: colorScheme.surface,
						borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
					),
					child: Column(
						children: [
							Row(
								children: [
									TextButton(
										onPressed: () => Navigator.of(sheetContext).pop(),
										child: const Text('Cancelar'),
									),
									const Spacer(),
									TextButton(
										onPressed: () {
											Navigator.of(sheetContext).pop(
												TimeOfDay(hour: temp.hour, minute: temp.minute),
											);
										},
										child: const Text('Seleccionar'),
									),
								],
							),
							Expanded(
								child: CupertinoDatePicker(
                  showTimeSeparator: true,
									mode: CupertinoDatePickerMode.time,
									use24hFormat: true,
									initialDateTime: temp,
									onDateTimeChanged: (value) {
										temp = value;
									},
								),
							),
						],
					),
				);
			},
		);

		if (picked == null) return;
		setState(() {
			_selectedTime = picked;
		});
	}

	String _formatTime24h(TimeOfDay time) {
		final now = DateTime.now();
		final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
		return DateFormat('HH:mm').format(date);
	}
	
	Future<void> _pickUnicaDate() async {
		final picked = await showDatePicker(
			context: context,
			initialDate: _unicaDate ?? DateTime.now(),
			firstDate: DateTime.now(),
			lastDate: DateTime.now().add(const Duration(days: 365)),
		);
		if (picked == null) return;
		setState(() {
			_unicaDate = picked;
		});
	}

	void _submit() {
		final title = _titleController.text.trim();
		if (title.isEmpty) return;

		// Validar que tareas únicas tengan fecha seleccionada
		if (_frequency == TaskFrequency.unica && _unicaDate == null) {
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('Selecciona una fecha para la tarea única')),
			);
			return;
		}

		// Validar que tareas semanales tengan días seleccionados
		if (_frequency == TaskFrequency.semanal && _weekDaysSelected.isEmpty) {
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('Selecciona al menos un día para la tarea semanal')),
			);
			return;
		}

		widget.onSubmit(
			CreateTaskResult(
				title: title,
				time: _selectedTime == null ? null : _formatTime24h(_selectedTime!),
				frequency: _frequency,
				unicaDate: _unicaDate,
				weekDays: _frequency == TaskFrequency.semanal ? _weekDaysSelected : null,
				monthScheduleType: _frequency == TaskFrequency.mensual ? _monthScheduleType : null,
				monthSpecificDay: _frequency == TaskFrequency.mensual && _monthScheduleType == MonthScheduleType.specificDay ? _monthSpecificDay : null,
				monthWeek: _frequency == TaskFrequency.mensual && _monthScheduleType == MonthScheduleType.weekPattern ? _monthWeek : null,
				monthWeekDay: _frequency == TaskFrequency.mensual && _monthScheduleType == MonthScheduleType.weekPattern ? _monthWeekDay : null,
			),
		);
	}
	
	String _getUnicaDateDisplay() {
		if (_unicaDate == null) return 'Selecciona una fecha';
		return DateFormat('d/M/yyyy', 'es').format(_unicaDate!);
	}

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		final textTheme = Theme.of(context).textTheme;
		final screenHeight = MediaQuery.sizeOf(context).height;
		final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
		
		// Limitar altura máxima del modal: 80% de la pantalla sin contar el teclado
		final maxModalHeight = (screenHeight * 0.92) - keyboardHeight;

		Widget frequencyChip(TaskFrequency value, String label) {
			return ChoiceChip(
				label: Text(label),
				selected: _frequency == value,
				onSelected: (_) {
					setState(() {
						_frequency = value;
						// Reset valores cuando cambias de frecuencia
						if (value == TaskFrequency.semanal) {
							_weekDaysSelected.clear();
						}
					});
					
					// Abrir automáticamente date picker para tareas únicas
					if (value == TaskFrequency.unica && _unicaDate == null) {
						Future.delayed(const Duration(milliseconds: 200), _pickUnicaDate);
					}
				},
			);
		}

		return SafeArea(
			top: false,
			child: AnimatedPadding(
				duration: const Duration(milliseconds: 180),
				curve: Curves.easeOut,
				padding: EdgeInsets.only(
					left: 14,
					right: 14,
					bottom: keyboardHeight + 14,
					top: 14,
				),
				child: ConstrainedBox(
					constraints: BoxConstraints(
						maxHeight: maxModalHeight,
					),
					child: Material(
						color: colorScheme.surface,
						borderRadius: BorderRadius.circular(15),
						child: SingleChildScrollView(
							physics: const ClampingScrollPhysics(),
							child: Padding(
								padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
								child: Column(
									mainAxisSize: MainAxisSize.min,
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											children: [
												Text(
													widget.isEditMode ? 'Editar tarea' : 'Nueva tarea',
													style: textTheme.titleLarge,
												),
												const Spacer(),
												IconButton(
													onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
													icon: const Icon(Icons.close),
												),
											],
										),
										const SizedBox(height: 8),
										Text('Titulo', style: textTheme.bodyMedium),
										const SizedBox(height: 6),
										TextField(                    
											controller: _titleController,
											textInputAction: TextInputAction.next,
											decoration: const InputDecoration(
												hintText: '¿Que necesitas hacer?',
											),
										),
										const SizedBox(height: 12),
										Text('Hora (opcional)', style: textTheme.bodyMedium),
										const SizedBox(height: 6),
										Row(
											children: [
												Expanded(
													child: InkWell(
														borderRadius: BorderRadius.circular(12),
														onTap: _pickTime,
														child: InputDecorator(
															decoration: const InputDecoration(),
															child: Row(
																children: [
																	Text(
																		_selectedTime == null ? '--:--' : _formatTime24h(_selectedTime!),
																		style: textTheme.bodyLarge,
																	),
																	const Spacer(),
																	const Icon(Icons.access_time),
																],
															),
														),
													),
												),
												if (_selectedTime != null)
													IconButton(
														onPressed: () {
															setState(() {
																_selectedTime = null;
															});
														},
														icon: const Icon(Icons.close_rounded),
														iconSize: 20,
													),
											],
										),
										const SizedBox(height: 12),
										Text('Frecuencia', style: textTheme.bodyMedium),
										const SizedBox(height: 8),
										Wrap(
											spacing: 8,
											runSpacing: 8,
											children: [
												frequencyChip(TaskFrequency.unica, 'Única'),
												frequencyChip(TaskFrequency.diaria, 'Diaria'),
												frequencyChip(TaskFrequency.semanal, 'Semanal'),
												frequencyChip(TaskFrequency.mensual, 'Mensual'),
											],
										),
										const SizedBox(height: 14),
										_buildFrequencyDetails(colorScheme, textTheme),
										const SizedBox(height: 14),
										SizedBox(
											width: double.infinity,
											child: FilledButton.icon(
												onPressed: _submit,
												icon: Icon(widget.isEditMode ? Icons.check : Icons.add),
												label: Text(widget.isEditMode ? 'Guardar cambios' : 'Crear tarea'),
											),
										),
									],
								),
							),
						),
					),
				),
			),
		);
	}
	
	Widget _buildFrequencyDetails(ColorScheme colorScheme, TextTheme textTheme) {
		switch (_frequency) {
			case TaskFrequency.diaria:
				return Text(
					'Se ejecuta todos los días',
					style: textTheme.bodyMedium?.copyWith(
						color: colorScheme.onSurfaceVariant,
					),
				);
			
			case TaskFrequency.unica:
				return Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						InkWell(
							borderRadius: BorderRadius.circular(12),
							onTap: _pickUnicaDate,
							child: InputDecorator(
								decoration: const InputDecoration(),
								child: Row(
									children: [
										Text(
											_getUnicaDateDisplay(),
											style: TextStyle(
												fontSize: 16,
												color: _unicaDate == null ? Colors.grey : null,
											),
										),
										const Spacer(),
										const Icon(Icons.calendar_today),
									],
								),
							),
						),
					],
				);
			
			case TaskFrequency.semanal:
				return _buildSemanal(textTheme, colorScheme);
			
			case TaskFrequency.mensual:
				return _buildMensual(textTheme, colorScheme);
		}
	}
	
	Widget _buildSemanal(TextTheme textTheme, ColorScheme colorScheme) {
		const daysOfWeek = ['L', 'M', 'W', 'J', 'V', 'S', 'D'];
		
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text('Selecciona los días', style: textTheme.bodyMedium),
				const SizedBox(height: 8),
				Wrap(
					spacing: 8,
					runSpacing: 8,
					children: List.generate(7, (index) {
						final isSelected = _weekDaysSelected.contains(index);
						return FilterChip(
							label: Text(daysOfWeek[index]),
							selected: isSelected,
							onSelected: (_) {
								setState(() {
									if (isSelected) {
										_weekDaysSelected.remove(index);
									} else {
										_weekDaysSelected.add(index);
									}
									_weekDaysSelected.sort();
								});
							},
						);
					}),
				),
			],
		);
	}
	
	Widget _buildMensual(TextTheme textTheme, ColorScheme colorScheme) {
		const weekLabels = ['Primera', 'Segunda', 'Tercera', 'Cuarta', 'Última'];
		const dayLabels = ['L', 'M', 'W', 'J', 'V', 'S', 'D'];
		
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// Toggle entre tipos
				Wrap(
					spacing: 8,
					runSpacing: 8,
					children: [
						ChoiceChip(
							label: const Text('Día del mes'),
							selected: _monthScheduleType == MonthScheduleType.specificDay,
							onSelected: (_) {
								setState(() {
									_monthScheduleType = MonthScheduleType.specificDay;
								});
							},
						),
						ChoiceChip(
							label: const Text('Patrón'),
							selected: _monthScheduleType == MonthScheduleType.weekPattern,
							onSelected: (_) {
								setState(() {
									_monthScheduleType = MonthScheduleType.weekPattern;
								});
							},
						),
					],
				),
				const SizedBox(height: 12),
				
				if (_monthScheduleType == MonthScheduleType.specificDay)
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text('Selecciona el día del mes', style: textTheme.bodyMedium),
							const SizedBox(height: 8),
							Wrap(
								spacing: 6,
								runSpacing: 6,
								children: List.generate(31, (index) {
									final day = index + 1;
									final isSelected = _monthSpecificDay == day;
									return InkWell(
										onTap: () {
											setState(() {
												_monthSpecificDay = day;
											});
										},
										child: Container(
											width: 36,
											height: 36,
											decoration: BoxDecoration(
												color: isSelected
													? colorScheme.primary
													: colorScheme.surface,
												border: Border.all(
													color: isSelected
														? colorScheme.primary
														: colorScheme.outline,
													width: isSelected ? 0 : 1,
												),
												borderRadius: BorderRadius.circular(8),
											),
											alignment: Alignment.center,
											child: Text(
												day.toString(),
												style: TextStyle(
													color: isSelected
														? colorScheme.onPrimary
														: colorScheme.onSurface,
													fontSize: 12,
													fontWeight: FontWeight.w500,
												),
											),
										),
									);
								}),
							),
						],
					)
				else
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text('Semana del mes', style: textTheme.bodyMedium),
							const SizedBox(height: 8),
							Wrap(
								spacing: 8,
								runSpacing: 8,
								children: List.generate(5, (index) {
									final isSelected = _monthWeek == index;
									return ChoiceChip(
										label: Text(weekLabels[index]),
										selected: isSelected,
										onSelected: (_) {
											setState(() {
												_monthWeek = index;
											});
										},
									);
								}),
							),
							const SizedBox(height: 12),
							Text('Día de la semana', style: textTheme.bodyMedium),
							const SizedBox(height: 8),
							Wrap(
								spacing: 8,
								runSpacing: 8,
								children: List.generate(7, (index) {
									final isSelected = _monthWeekDay == index;
									return ChoiceChip(
										label: Text(dayLabels[index]),
										selected: isSelected,
										onSelected: (_) {
											setState(() {
												_monthWeekDay = index;
											});
										},
									);
								}),
							),
						],
					),
			],
		);
	}
}

class CreateTaskScreen extends StatelessWidget {
	const CreateTaskScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.black45,
			body: Align(
				alignment: Alignment.bottomCenter,
				child: CreateTaskFormSheet(
					onClose: () => Navigator.of(context).pop(),
					onSubmit: (_) => Navigator.of(context).pop(),
				),
			),
		);
	}
}
