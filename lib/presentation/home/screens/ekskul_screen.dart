import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/presentation/ekskul/views/ekskul_detail.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/widgets/card_ekskul.dart';
import 'package:stacked_listview/stacked_listview.dart';

class EkskulScreen extends StatelessWidget {
  const EkskulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider(
        create: (context) => EkskulCubit()..displayEkskul(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: BlocBuilder<EkskulCubit, EkskulState>(
            builder: (context, state) {
              if (state is EkskulLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is EkskulLoaded) {
                return Expanded(
                  child: StackedListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemExtent: width * 0.475,
                    itemCount: state.ekskul.length,
                    scrollDirection: Axis.horizontal,
                    builder: (context, index) {
                      return GestureDetector(
                        onTap: () => AppNavigator.push(
                          context,
                          EkskulDetail(
                            ekskul: state.ekskul[index],
                          ),
                        ),
                        child: CardEkskul(
                          key: ValueKey(state.ekskul[index].namaEkskul),
                          title: state.ekskul[index].namaEkskul,
                        ),
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
