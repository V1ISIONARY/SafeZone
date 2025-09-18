import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneInfoContainer extends StatelessWidget {
  final String zoneType;
  final String distance;
  final String eta;
  final String startAddress;
  final String endAddress;
  final int numberOfSteps;
  final LatLng zoneCoordinates;
  final Color routeColor;
  final VoidCallback? onClose;

  const ZoneInfoContainer({
    Key? key,
    required this.zoneType,
    required this.distance,
    required this.eta,
    this.startAddress = "Current Location",
    this.endAddress = "Unknown Location",
    this.numberOfSteps = 0,
    required this.zoneCoordinates,
    required this.routeColor,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: routeColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: routeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                zoneType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: routeColor,
                ),
              ),
              const Spacer(),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.straighten,
                  title: "Distance",
                  value: distance,
                  color: routeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.access_time,
                  title: "Walking Time",
                  value: eta,
                  color: routeColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: routeColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.location_on,
                  label: "Destination",
                  value: endAddress,
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.map,
                  label: "Coordinates",
                  value:
                      "${zoneCoordinates.latitude.toStringAsFixed(4)}, ${zoneCoordinates.longitude.toStringAsFixed(4)}",
                ),
                if (numberOfSteps > 0) ...[
                  const SizedBox(height: 8),
                  _DetailRow(
                    icon: Icons.list,
                    label: "Steps",
                    value: "$numberOfSteps directions",
                  ),
                ],
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.access_time,
                  label: "Updated",
                  value: TimeOfDay.now().format(context),
                ),
              ],
            ),
          ),

         
        ],
      ),
    );
  }
}


class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


